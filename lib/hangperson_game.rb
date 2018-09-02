class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @@max_guesses = 7     ## max number of guesses; constant for use across the app
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
    end

    char.downcase!

    return false if @guesses.include?(char) || @wrong_guesses.include?(char)

    if @word.include? char
      @guesses += char
    else
      @wrong_guesses += char
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
    return :win  if @word == word_with_guesses
    return :lose if @wrong_guesses.length >= @@max_guesses
    :play
  end

  ## allow access to avoid 'magic numbers' in class HangpersonApp
  def self.max_guesses
    @@max_guesses
  end

end
