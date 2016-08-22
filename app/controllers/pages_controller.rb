class PagesController < ApplicationController
  def letsencrypt
    # http://collectiveidea.com/blog/archives/2016/01/12/lets-encrypt-with-a-rails-app-on-heroku/
    # use your code here, not mine
    render text: "VZm19jETsVMB69LDv3MCbeHtn7k6LrCqn9RuBJYrByQ.FWL9KYn1l5bu2Njcv4UdK6U0haCZGGtz7HEnmmxBhHk"
  end
end