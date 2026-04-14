class AliyunOss
  CarrierWave.configure do |config|
    config.storage           = :aliyun
    config.aliyun_access_id  = Yetting.aliyun_oss["aliyun_access_id"]
    config.aliyun_access_key = Yetting.aliyun_oss["aliyun_access_key"]
    config.aliyun_bucket     = Yetting.aliyun_oss["aliyun_bucket"]
    config.aliyun_internal   = Yetting.aliyun_oss["aliyun_internal"]
    config.aliyun_area     = Yetting.aliyun_oss["end_point"]
  end

  @uploader = CarrierWave::Uploader::Base.new
  @bucket = CarrierWave::Aliyun::Bucket.new(@uploader)

  def self.instance
    @bucket
  end

end
