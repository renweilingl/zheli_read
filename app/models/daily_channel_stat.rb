# frozen_string_literal: true

class DailyChannelStat < ApplicationRecord
  self.table_name = 'daily_channel_stats'

  scope :by_date, ->(date) { where(stat_date: date) }
  scope :by_channel, ->(channel) { where(channel: channel) }
  scope :platform_summary, -> { where(channel: nil) }
end
