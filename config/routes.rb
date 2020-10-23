Rails.application.routes.draw do
  root to: 'blogs#index'
  resources :blogs

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
