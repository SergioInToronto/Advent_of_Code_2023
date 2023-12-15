re_line = ~r/^Game (\d+): (.*)$/
re_cubes = ~r/(\d+) (red|green|blue)/

{:ok, contents} = File.read("input.txt")
lines = String.split(String.trim(contents), "\n")

# max cubes:
# 12 red cubes
# 13 green cubes
# 14 blue cubes
cube_count_is_valid? = fn cube_count ->
  [_, count, color] = Regex.run(re_cubes, cube_count)
  case color do
    "red" ->
      String.to_integer(count) <= 12
    "green" ->
      String.to_integer(count) <= 13
    "blue" ->
      String.to_integer(count) <= 14
    _ ->
      raise ArgumentError, color <> " is not a valid color"
  end
end

game_possible? = fn game ->
  rounds = String.split(game, "; ")
  draws = Enum.map(rounds, fn round ->
    String.split(round, ", ")
  end)
  Enum.all?(
    Enum.map(List.flatten(draws), fn val ->
      cube_count_is_valid?.(val)
    end)
  )
end

possible_game_ids = Enum.map(lines, fn line ->
  [_, game_no, game] = Regex.run(re_line, line)
  IO.write("Game " <> game_no <> "... ")

  possible = game_possible?.(game)
  IO.puts(possible)
  if possible do
    game_no
  else
    nil
  end
end)

possible_game_ids = possible_game_ids
  |> Enum.reject(&is_nil/1)
  |> Enum.map(&String.to_integer/1)

IO.puts("\nPart 1: #{Enum.sum(possible_game_ids)}")
