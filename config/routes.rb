Rails.application.routes.draw do
  root 'hiragana#index'
  
  get 'hiragana', to: 'hiragana#index', as: 'hiragana_index'
  get 'hiragana/quiz', to: 'hiragana#quiz', as: 'quiz_hiragana'
  post 'hiragana/check', to: 'hiragana#check_answer', as: 'check_hiragana'
  post 'hiragana/reset', to: 'hiragana#reset_score', as: 'reset_hiragana'
end
