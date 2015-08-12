module CampusSolutions
  class TermsAndConditions < PostingProxy

    def initialize(options = {})
      super(Settings.cs_terms_and_conditions_proxy, options)
      initialize_mocks if @fake
    end

    def self.field_mappings
      @field_mappings ||= FieldMapping.to_hash(
        [
          FieldMapping.required(:response, :UC_RESPONSE),
          FieldMapping.required(:aidYear, :AID_YEAR)
        ]
      )
    end

    def root_xml_node
      'Terms_Conditions'
    end

    def xml_filename
      'terms_and_conditions.xml'
    end

    def default_post_params
      # TODO ID is hardcoded until we can use ID crosswalk service to convert CalNet ID to CS Student ID
      {
        EMPLID: '25738808',
        INSTITUTION: 'UCB01',
        LASTUPDOPRID: '1086132'
      }
    end

    def instance_key
      "#{@uid}-#{params[:aidYear]}"
    end

    def url
      "#{@settings.base_url}/UC_FA_T_C.v1/post"
    end

    def build_feed(response)
      response.parsed_response['UC_FA_T_C_RSP']
    end

  end
end