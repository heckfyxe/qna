module ApplicationHelper
  def github_gist?(url)
    url.match /https?:\/\/gist.github.com\/[a-zA-Z0-9]*\/[a-z0-9]*/
  end

  def github_gist_id(url)
    url.split('/').last if github_gist?(url)
  end
end
