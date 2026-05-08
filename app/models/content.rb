class Content < ApplicationRecord
  belongs_to :content_group

  enum :content_type, {
    compilation: 'compilation',           # 合辑
    book: 'book', # 单本
    recommend: 'recommends' #推荐
  }, prefix: true

  CONTENT_TYPES = {
    compilation: '合辑',
    book: '单本',
    recommend: '推荐内容'
  }.freeze

  def content_type_name
    CONTENT_TYPES[content_type.to_sym] || content_type
  end
end
