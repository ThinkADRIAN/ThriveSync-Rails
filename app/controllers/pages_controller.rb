class PagesController < ApplicationController
  def letsencrypt
    # http://collectiveidea.com/blog/archives/2016/01/12/lets-encrypt-with-a-rails-app-on-heroku/
    # use your code here, not mine
    render text: "um3keHHyMrzs3rT8c6H67Ms0biTGGQgfqh7O0A3a988.FWL9KYn1l5bu2Njcv4UdK6U0haCZGGtz7HEnmmxBhHk"
  end
end