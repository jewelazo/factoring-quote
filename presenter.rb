module Presenter
  def print_welcome
    # print the welcome message
    message = ["###################################",
               "#   Welcome to Chita Factoring Quote #",
               "###################################"].join("\n")
    puts message
  end

  def print_exit
    # print the welcome message
    message = ["####################################",
               "# Thanks for using Chita Factoring Quote #",
               "####################################"].join("\n")
    puts message
  end
end
