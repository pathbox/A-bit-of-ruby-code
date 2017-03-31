class FindInBatchesExtend

  # 该方法实现find_in_batches 功能，但是order by 是以 updated_at 排序，在使用ES增量同步时，提高了效率
  def self.find_in_batches(relation, order_cloumn = "updated_at", batch_size = 1000)
    relation = relation.order("#{order_cloumn} ASC").limit(batch_size)
    records = relation.to_a

    while records.any?
      records_size = records.size
      offset_column = records.last.send("#{order_cloumn}")

      yield records

      break if records_size < batch_size
      records = relation.where("#{order_cloumn} >= ?", offset_column).to_a
    end
  end
end