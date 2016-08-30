IO.puts "This is Pig Latin"
IO.puts "--------------------------------------------------"

defmodule PigLatin do
  @vowels ["a","e","i","o","u"]

  def is_vowel?(character) do
    Enum.any?(@vowels, fn(c) -> character == c end)
  end

  def return_first_vowel_index([_ | tail], _) when tail == [] do
    nil
  end

  def return_first_vowel_index([head | tail], index) do
    if is_vowel?(head) do
      index
    else
      return_first_vowel_index(tail, index+1)
    end
  end

  def convert_to_pig_latin(word) do
    characters_list = String.graphemes word
    first_vowel_index = return_first_vowel_index(characters_list, 0) 
    if first_vowel_index == 0 do
      word
    else
      split_word = String.split_at(word, first_vowel_index)
      word_from_vowel = elem(split_word, 1)
      word_before_vowel = elem(split_word, 0)
      word_from_vowel <> word_before_vowel <> "ay"
    end
  end
end

word = "hello"
expected_result = "ellohay"

IO.puts PigLatin.convert_to_pig_latin(word) == expected_result
