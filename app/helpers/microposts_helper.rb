module MicropostsHelper
  def load_feed_page user, page
    user.feed.page(page)
  rescue StandardError
    nil
  end
end
