defmodule War do
  @moduledoc """
    Documentat#ion for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many addit#ional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """

  def deal(shuf) do
    {p2, p1} = split_deck(shuf, [], [], 0)
    winner = play(p1, p2)
    IO.inspect(winner, limit: :infinity)
  end

  #funcion accepts a shuffled deck and splits it between 2 players in an alternating fas#ion
  defp split_deck([], pile1, pile2, _), do: {pile1, pile2}
  defp split_deck(list, pile1, pile2, index) do
    cond do
      rem(index, 2) == 0 -> split_deck(tl(list), [hd(list) | pile1], pile2, index + 1)
      true -> split_deck(tl(list), pile1, [hd(list) | pile2], index + 1)
    end
  end

  # funcion accepts a two cards and returns the winner of the round
  def getRank(card1, card2) do
    case rank(card1) > rank(card2) do
      true -> :player1
      false -> case rank(card1) < rank(card2) do
        true -> :player2
        false -> :war
      end
    end
  end

  # funcion accepts a list of cards and sorts it in descending order
  def sortCardList(list) do
    Enum.sort(list, fn num1, num2 ->
      rank(num1) > rank(num2)
    end)
  end

  # funcion accepts a card and returns its rank
  def rank(num) when num in 1..13 do
    case num do
      1 -> 14
      _ -> num
    end
  end

  # funcion accepts a deck shuffles it between 2 players, play the game to check the equality of the cards
  def play([], pile2), do: pile2 # when player 1 has no cards
  def play(pile1, []), do: pile1 # when player 2 has no cards

  def play(hand1, hand2) do
    if hand1 != hand2 do # when pile1 and pile2 are not equal
      IO.puts("Card1 = #{hd(hand1)} Card2 = #{hd(hand2)}  \n")

      case getRank(hd(hand1), hd(hand2)) do
      :player1 ->
        IO.puts("Player 1 wins the round")
        IO.puts("pile1: ")
        IO.inspect(hand1)
        IO.puts("pile2: ")
        IO.inspect(hand2)
        IO.puts("  \n")
        play(tl(hand1) ++ [hd(hand1), hd(hand2)], tl(hand2))
      :player2 ->
        IO.puts("Player 2 wins the round")
        IO.puts("pile1 = #{hand1} pile2 = #{hand2}  \n")
        play(tl(hand1), tl(hand2) ++ [hd(hand2), hd(hand1)])
      :war ->
        IO.puts("War! \n")
        war(tl(hand1), tl(hand2), [hd(hand1), hd(hand2)], [])
      end

    else # when pile1 and pile2 are equal
      warCards = hand1 ++ hand2
      sortedCards = sortCardList(warCards)
      sortedCards
    end
end

  # funcion accepts a deck and returns the winner of the game
  def war([], pile2, war_pile, _), do: pile2 ++ war_pile # when player 1 has no cards
  def war(pile1, [], war_pile, _), do: pile1 ++ war_pile # when player 2 has no cards

  def war(hand1, hand2, war_pile, _new_war_pile) do
    if length(hand1) > 1 and length(hand2) > 1 do # when both players have more than 1 card
      new_war_pile = war_pile ++ [hd(hand1), hd(hand2), hd(tl(hand1)), hd(tl(hand2))]
      sortedWar = sortCardList(new_war_pile)
      IO.puts("Sorted War")
      IO.inspect(sortedWar)
      IO.puts("WarCard1 = #{hd(tl(hand1))} WarCard2 = #{hd(tl(hand2))}  \n")
      case getRank(hd(tl(hand1)), hd(tl(hand2))) do
        :player1 ->
          IO.puts("Player 1 wins the war")
          IO.puts("pile1 = #{hand1} pile2 = #{hand2}  \n")
          play(tl(tl(hand1)) ++ sortedWar, tl(tl(hand2)))
        :player2 ->
          play(tl(tl(hand1)), tl(tl(hand2)) ++ sortedWar)
        :war ->
          war(tl(tl(hand1)), tl(tl(hand2)), sortedWar, [])
      end
    else
      cond do
        length(hand1) < length(hand2) and length(hand1) != 0 -> # when player 1 has less cards than player 2
          new_war_pile = war_pile ++ [hd(hand1), hd(hand2)]
          sortedWar = sortCardList(new_war_pile)
          play(tl(hand1), tl(hand2) ++ sortedWar)

        length(hand2) < length(hand1) and length(hand2) != 0  -> # when player 2 has less cards than player 1
          new_war_pile = war_pile ++ [hd(hand2), hd(hand1)]
          sortedWar = sortCardList(new_war_pile)
          play(tl(hand1) ++ sortedWar, tl(hand2))
        end
    end
  end
end
