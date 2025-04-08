module PackageService
  class Manager
    def self.consume_listing(user_package)
      user_package.increment!(:listings_consumed)
    end

    def self.handle_listing_deletion(listing)
      return unless listing.active?

      user_package = listing.user.active_package
      time_live = Time.current - listing.published_at

      if time_live < 6.hours
        user_package.decrement!(:listings_consumed)
      end
    end
  end
end