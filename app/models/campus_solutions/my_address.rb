module CampusSolutions
  class MyAddress < UserSpecificModel

    include Cache::LiveUpdatesEnabled
    include Cache::FreshenOnWarm
    include Cache::JsonAddedCacher

    def get_feed_internal
      CampusSolutions::Address.new({user_id: @uid}).get
    end

    def update(params = {})
      CampusSolutions::Address.new({user_id: @uid}).post(params)
    end

  end
end
