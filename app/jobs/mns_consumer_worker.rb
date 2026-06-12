# 阿里云MNS消息消费者Worker
# 使用Sidekiq定时任务持续监听MNS队列
class MnsConsumerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :zheli_low, retry: false

  # 每次处理的最大消息数
  MAX_MESSAGES_PER_RUN = 10
  
  # 长轮询等待时间(秒)
  WAIT_SECONDS = 5

  def perform
    logger.info "开始接收MNS消息..."
    
    begin
      client = AliyunMnsConfig.client
      
      # 批量接收消息
      messages = receive_messages(client, MAX_MESSAGES_PER_RUN)
      
      if messages.empty?
        logger.info "MNS队列为空,无消息需要处理"
        return
      end
      
      logger.info "接收到 #{messages.size} 条MNS消息"
      
      # 处理每条消息
      messages.each do |message|
        process_message(message, client)
      end
      
      logger.info "成功处理 #{messages.size} 条MNS消息"
      
    rescue => e
      logger.error "MNS消息处理失败: #{e.message}"
      logger.error e.backtrace.join("\n")
      raise e
    end
  end

  private

  # 接收消息
  def receive_messages(client, count)
    messages = []
    
    count.times do
      begin
        message = client.receive_message(wait_seconds: WAIT_SECONDS)
        messages << message if message
      rescue => e
        logger.error "接收MNS消息失败: #{e.message}"
        break
      end
    end
    
    messages
  end

  # 处理单条消息
  def process_message(message, client)
    logger.info "处理MNS消息 ID: #{message[:message_id]}"
    
    begin
      # 尝试Base64解码消息体
      decoded_body = decode_message_body(message[:message_body])
      
      logger.info "消息内容(原始): #{message[:message_body][0..200]}..." if message[:message_body].length > 200
      logger.info "消息内容(解码后): #{decoded_body[0..200]}..." if decoded_body.length > 200
      
      # 尝试解析为JSON
      body = parse_json_content(decoded_body)
      
      # 根据消息类型进行不同处理
      handle_message(body, message)
      
      # 删除已处理的消息
      client.delete_message(message[:receipt_handle])
      logger.info "消息已处理并删除: #{message[:message_id]}"
      
    rescue => e
      logger.error "消息处理异常: #{e.message}"
      logger.error e.backtrace.join("\n")
      # 不删除消息,让它可以重新被消费
      raise e
    end
  end

  # Base64解码消息体
  def decode_message_body(raw_body)
    return raw_body if raw_body.blank?
    
    begin
      # Base64解码并强制转换为UTF-8编码
      decoded = Base64.decode64(raw_body).force_encoding('UTF-8')
      logger.debug "消息Base64解码成功"
      decoded
    rescue => e
      logger.warn "Base64解码失败,使用原始内容: #{e.message}"
      raw_body
    end
  end
  
  # 解析JSON内容
  def parse_json_content(content)
    return content if content.blank?
    
    begin
      parsed = JSON.parse(content)
      logger.debug "消息JSON解析成功"
      parsed
    rescue JSON::ParserError => e
      logger.debug "消息不是JSON格式,返回原始内容: #{e.message}"
      content
    end
  end

  # 处理JSON格式消息
  def handle_message(data, message)
    # TODO: 根据实际业务需求实现消息处理逻辑
    # 示例:
    # case data['type']
    # when 'order_created'
    #   handle_order_created(data)
    # when 'user_registered'
    #   handle_user_registered(data)
    # end
    
    logger.info "收到JSON消息: #{data.inspect}"
  end

  # 处理纯文本消息
  def handle_text_message(text, message)
    # TODO: 根据实际业务需求实现文本消息处理逻辑
    logger.info "收到文本消息: #{text}"
  end

  # 示例: 处理订单创建消息
  def handle_order_created(data)
    # order_id = data['order_id']
    # OrderService.process_new_order(order_id)
    logger.info "处理订单创建: #{data.inspect}"
  end

  # 示例: 处理用户注册消息
  def handle_user_registered(data)
    # user_id = data['user_id']
    # UserService.welcome_new_user(user_id)
    logger.info "处理用户注册: #{data.inspect}"
  end
end

