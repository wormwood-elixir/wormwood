defmodule Wormwood.Examples.StaticData do
  @moduledoc false
  def users do
    [
      %{:id => 1, :name => "Foilz", :email => "ilovesecurity@please-dont-email-this.really"},
      %{:id => 2, :name => "Batman", :email => "i@ambat.man"},
      %{:id => 3, :name => "Vivi", :email => "blackmages@zidane.beep"},
      %{:id => 4, :name => "Parrot", :email => "bird@caw.squak"},
      %{:id => 5, :name => "Foilz", :email => "ilovesecurity@please-dont-email-this.really"}
    ]
  end

  def messages do
    [
      %{:id => 1, :message => "Christmas is coming.", :from => 1},
      %{:id => 2, :message => "The quick brown fox jumps over the lazy dog.", :from => 1},
      %{:id => 3, :message => "Joe made the sugar cookies; Susan decorated them.", :from => 2},
      %{:id => 4, :message => "I am never at home on Sundays.", :from => 4},
      %{:id => 5, :message => "HThere were white out conditions in the town; subsequently, the roads were impassable.", :from => 5},
      %{:id => 6, :message => "I'd rather be a bird than a fish.", :from => 2},
      %{:id => 7, :message => "He told us a very exciting adventure story.", :from => 3},
      %{:id => 8, :message => "The lake is a long way from here.", :from => 5},
      %{:id => 9, :message => "How was the math test?", :from => 5},
      %{:id => 1, :message => "Christmas is coming.", :from => 1},
    ]
  end
end
