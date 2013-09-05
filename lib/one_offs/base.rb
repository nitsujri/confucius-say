class OneOffs
  class Base

    def start_info(action_name)
      @start_data ||= ExtraData.where({
        :storable_type => "StartAtData"
      }).first_or_create

      #make sure data exists
      if @start_data.data.blank?
        @start_data.data = {action_name.to_sym => 0}
        @start_data.save
      elsif @start_data.data[action_name.to_sym].blank?
        @start_data.data = @start_data.data.merge({action_name.to_sym => 0})
        @start_data.save
      end

      @start_data
    end

    def increment_start_pos(action_name)
      #increment the start position
      start_data = start_info(action_name).data
      start_data[action_name.to_sym] += 1
      start_info(action_name).update_attribute(:data, start_data)
    end

    def start_position_for(action_name)
      start_info(action_name).data[action_name.to_sym] || 0
    end
  end
end