re_first_num = ~r/(\d)/
re_last_num = ~r/(\d)[^\d]*$/


IO.puts("Hello world from Elixir")

{:ok, contents} = File.read("input.txt")
# IO.puts(String.length(contents))

lines = String.split(String.trim(contents), "\n")
numbers = Enum.map(lines, fn line ->
  [_, d1] = Regex.run(re_first_num, line)
  [_, d2] = Regex.run(re_last_num, line)
  d1 <> d2
end)

# total = Enum.sum(Enum.map(numbers, String.to_integer))
total = Enum.sum(Enum.map(numbers, fn val -> String.to_integer(val) end))
IO.puts("Part 1: " <> Integer.to_string(total))

########## Part 2 ##########
# 52963 is too low
# 52963 was the answer in Python too. What's going on...
# "oneight" problem. A digit word may be part of another
# As a result I cannot convert the full text up front like I wanted

to_num = fn digit ->
  # digit may be a word or a string containing a number
  digit = Regex.replace(~r/one/, digit, "1")
  digit = Regex.replace(~r/two/, digit, "2")
  digit = Regex.replace(~r/three/, digit, "3")
  digit = Regex.replace(~r/four/, digit, "4")
  digit = Regex.replace(~r/five/, digit, "5")
  digit = Regex.replace(~r/six/, digit, "6")
  digit = Regex.replace(~r/seven/, digit, "7")
  digit = Regex.replace(~r/eight/, digit, "8")
  digit = Regex.replace(~r/nine/, digit, "9")

  digit
end

digit = "[0-9]|one|two|three|four|five|six|seven|eight|nine"
digit_rev = "enin|thgie|neves|xis|evif|ruof|eerht|owt|eno|[0-9]"
{:ok, re_first} = Regex.compile("(#{digit})")
{:ok, re_last_rev} = Regex.compile("(#{digit_rev})")

lines = String.split(String.trim(contents), "\n")
numbers = Enum.map(lines, fn line ->
  [_, d1] = Regex.run(re_first, line)
  [_, d2] = Regex.run(re_last_rev, String.reverse(line))
  d2 = String.reverse(d2)
  d1 <> d2
end)

IO.puts("Finished. Calcing total...")

numbers = Enum.map(numbers, fn val -> String.to_integer(to_num.(val)) end)
total = Enum.sum(numbers)
IO.puts("Part 2: " <> Integer.to_string(total))

# 53338 is wrong :(
# 53355 is wrong :(
# Found the final problem. It's still the "oneight" problem
# "twone" matches "two" instead of "one" for the last digit
# solved it lazily by reversing string before searching
