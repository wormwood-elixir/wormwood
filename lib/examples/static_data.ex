defmodule Wormwood.Examples.StaticData do
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
      %{:id => 1, :message => "Hello World", :from => 1},
      %{:id => 2, :message => "Hello World", :from => 1},
      %{:id => 3, :message => "Hello World", :from => 2},
      %{:id => 4, :message => "Hello World", :from => 4},
      %{:id => 5, :message => "Hello World", :from => 5},
      %{:id => 6, :message => "Hello World", :from => 2},
      %{:id => 7, :message => "Hello World", :from => 3},
      %{:id => 8, :message => "Hello World", :from => 5},
      %{:id => 9, :message => "Hello World", :from => 5}
    ]
  end
end
