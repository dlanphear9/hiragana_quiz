class HiraganaController < ApplicationController
  # Skip CSRF verification for quiz actions
  # This is safe for a learning app and avoids issues when JavaScript isn't loaded
  skip_before_action :verify_authenticity_token, only: [:check_answer, :reset_score]

  # Hiragana chart data - basic characters
  HIRAGANA_DATA = {
    # Vowels
    'あ' => 'a', 'い' => 'i', 'う' => 'u', 'え' => 'e', 'お' => 'o',
    # K row
    'か' => 'ka', 'き' => 'ki', 'く' => 'ku', 'け' => 'ke', 'こ' => 'ko',
    # S row
    'さ' => 'sa', 'し' => 'shi', 'す' => 'su', 'せ' => 'se', 'そ' => 'so',
    # T row
    'た' => 'ta', 'ち' => 'chi', 'つ' => 'tsu', 'て' => 'te', 'と' => 'to',
    # N row
    'な' => 'na', 'に' => 'ni', 'ぬ' => 'nu', 'ね' => 'ne', 'の' => 'no',
    # H row
    'は' => 'ha', 'ひ' => 'hi', 'ふ' => 'fu', 'へ' => 'he', 'ほ' => 'ho',
    # M row
    'ま' => 'ma', 'み' => 'mi', 'む' => 'mu', 'め' => 'me', 'も' => 'mo',
    # Y row
    'や' => 'ya', 'ゆ' => 'yu', 'よ' => 'yo',
    # R row
    'ら' => 'ra', 'り' => 'ri', 'る' => 'ru', 'れ' => 're', 'ろ' => 'ro',
    # W row
    'わ' => 'wa', 'を' => 'wo',
    # N
    'ん' => 'n'
  }.freeze

  def index
    @hiragana_chart = HIRAGANA_DATA
    @random_char = get_random_character
    @score = session[:score] || 0
    @total = session[:total] || 0
  end

  def quiz
    @random_char = get_random_character
    @score = session[:score] || 0
    @total = session[:total] || 0
    @last_answer = session[:last_answer]
    @last_correct = session[:last_correct]
    @last_hiragana = session[:last_hiragana]
    
    # Clear flash messages after displaying
    session[:last_answer] = nil
    session[:last_correct] = nil
    session[:last_hiragana] = nil
  end

  def check_answer
    hiragana = params[:hiragana]
    user_answer = params[:answer]&.downcase&.strip
    correct_answer = HIRAGANA_DATA[hiragana]&.downcase

    session[:total] = (session[:total] || 0) + 1

    if user_answer == correct_answer
      session[:score] = (session[:score] || 0) + 1
      session[:last_correct] = true
      flash[:success] = "Correct! #{hiragana} = #{correct_answer}"
    else
      session[:last_correct] = false
      flash[:error] = "Incorrect. #{hiragana} = #{correct_answer} (you answered: #{user_answer})"
    end

    session[:last_answer] = user_answer
    session[:last_hiragana] = hiragana

    redirect_to quiz_hiragana_path
  end

  def reset_score
    session[:score] = 0
    session[:total] = 0
    redirect_to hiragana_index_path
  end

  private

  def get_random_character
    HIRAGANA_DATA.keys.sample
  end
end

