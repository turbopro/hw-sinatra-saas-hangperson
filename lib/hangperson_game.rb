class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess char
    if char.nil? || !char.match(/\A[a-z]\z/i)
      raise ArgumentError
      return false
    end
    char.downcase!

    return false if @guesses.include?(char) || @wrong_guesses.include?(char)

    if @word.include? char
      @guesses += char
      true
    else
      @wrong_guesses += char
      true
    end
  end

  def word_with_guesses
    game_display = '-' * @word.length
    @guesses.each_char do |guess_char|
      @word.split('').each_with_index do |word_char, idx|
        game_display[idx] = word_char if word_char == guess_char
      end
    end
    game_display
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    return :win  if @word == word_with_guesses
    :play
  end

end
