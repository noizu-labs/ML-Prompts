defmodule MnesiaMonitoring do
  @table_columns [
    :node,
    :online,
    :mnesia_status,
    :held_locks,
    :held_transactions,
    :disk_log_size,
    :core_log_size,
    :error,
    :time,
    :notes
  ]

  def cluster_summary() do
    nodes = Node.list() ++ [node()]
    summary = Task.async_stream(nodes, &({&1, node_summary(&1)}), max_concurrency: 32, timeout: :infinity)
              |> Enum.map(
                   fn
                     {:ok, {n, {:badrpc, _}}} -> %{node: n, online: :error}
                     {:ok, {_, v}} -> v
                   end
                 )

    print_summary_table(summary)
    print_notes(summary)
  end

  defp node_summary(node) do
    %{node: node, start: :os.system_time(:millisecond)}
    |> get_online_status()
    |> get_mnesia_status()
    |> get_lock_info()
    |> get_log_sizes()
    |> get_notes()
  end

  defp get_online_status(summary) do
    if Node.ping(summary.node) == :pong do
      IO.puts "Calling #{summary.node}"
      info = case :rpc.call(summary.node, Amnesia, :info, [:all],  30_000) do
               v = {:badrpc, _} ->
                 summary
                 |> put_in([:online], true)
                 |> put_in([:time], summary.start - :os.system_time(:millisecond))
                 |> put_in([:error], v)
                 |> put_in([:info], [])
               info ->
                 summary
                 |> put_in([:online], true)
                 |> put_in([:time], summary.start - :os.system_time(:millisecond))
                 |> put_in([:info], info)
             end |> tap(fn(_) -> IO.puts " finished #{summary.node}" end)




    else
      summary
      |> put_in([:online], false)
      |> put_in([:info], %{})
    end
  end

  defp get_mnesia_status(summary) do
    status = summary.info[:is_online]
    Map.put(summary, :mnesia_status, status)
  end

  defp get_lock_info(summary) do
    held_locks = summary.info[:held_locks]
    held_transactions =  summary.info[:held_transactions]
    summary
    |> Map.put(:held_locks, held_locks)
    |> Map.put(:held_transactions, held_transactions)
  end

  defp get_log_sizes(summary) do
    disk_log_size = summary.info[:disk_log_size]
    core_log_size = summary.info[:core_log_size]
    summary
    |> Map.put(:disk_log_size, disk_log_size)
    |> Map.put(:core_log_size, core_log_size)
  end

  defp get_notes(summary) do
    notes = []
            |> then(fn(notes) ->
      case summary.mnesia_status do
        :running -> notes
        _ -> ["Mnesia status: #{inspect summary.mnesia_status}" | notes]
      end
    end)
            |> then(fn(notes) ->
      if !summary.online do
        ["Node is offline" | notes]
      else
        notes
      end
    end)
            |> then(fn(notes) ->
      if length(summary.held_locks || []) > 0 do
        ["Held locks present" | notes]
      else
        notes
      end
    end)
            |> then(fn(notes) ->
      if length(summary.held_transactions || []) > 0 do
        ["Held transactions present" | notes]
      else
        notes
      end
    end)
    Map.put(summary, :notes, notes)
  end


  defp print_summary_table(summaries) do
    table = Enum.map(summaries, &row_from_summary/1)
    table_header = Enum.map(@table_columns, &Atom.to_string/1)

    column_widths = calculate_column_widths(table_header, table)

    formatted_table_header =
      Enum.zip(table_header, column_widths)
      |> Enum.map(fn {header, width} -> String.pad_trailing(header, width) end)
      |> Enum.join("|")

    formatted_table_rows =
      Enum.map(table, fn row ->
        Enum.zip(row, column_widths)
        |> Enum.map(fn {value, width} -> String.pad_trailing(to_string(value), width) end)
        |> Enum.join("|")
      end)

    IO.puts("Cluster Summary:")
    IO.puts(formatted_table_header)
    Enum.each(formatted_table_rows, &IO.puts/1)
  end

  defp calculate_column_widths(headers, table) do
    header_widths = Enum.map(headers, &String.length/1)
    data_widths =
      table
      |> Enum.map(fn(row) ->  Enum.map(row, fn(item) -> String.length(to_string(item)) end)    end)
      |> IO.inspect(label: "WIDTHS")


      for i <- 0 .. (length(header_widths) - 1) do
        c = Enum.map(data_widths, &(Enum.at(&1, i)))
        Enum.max([Enum.at(header_widths, i) | c])
      end
  end


  defp row_from_summary(summary) do
    Enum.map(@table_columns, &Map.get(summary, &1))
  end


  defp print_notes(summaries) do
    Enum.each(summaries, fn summary ->
      if length(summary.notes) > 0 do
        IO.puts("Notes for #{summary.node}:")
        Enum.each(summary.notes, &(IO.puts("\t#{&1}")))
      end
    end)
  end
end


MnesiaMonitoring.cluster_summary