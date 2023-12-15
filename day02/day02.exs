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
  IO.puts(possible && "possible" || "impossible")
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



###### Part 2 ######

cube_maxes = fn cube_counts ->
  init = %{"red" => 0, "green" => 0, "blue" => 0}
  result = Enum.reduce(cube_counts, init, fn (el, counts) ->
    [_, count, color] = Regex.run(re_cubes, el)
    # update syntax for Maps is unexpected to me:
    count = Enum.max([counts[color], String.to_integer(count)])
    %{counts | color => count}
  end)
  [result["red"], result["green"], result["blue"]]
end

calc_game_power = fn line ->
  [_, _, game] = Regex.run(re_line, line)
  rounds = String.split(game, "; ")
  draws = Enum.map(rounds, fn round ->
    String.split(round, ", ")
  end)

  draws
  |> List.flatten()
  |> cube_maxes.()
  |> IO.inspect()
  |> then(fn val ->
    Enum.product(val)
  end)
end

powers = Enum.map(lines, &calc_game_power.(&1))
IO.puts("Part 2: #{Enum.sum(powers)}")
