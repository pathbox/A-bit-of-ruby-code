require 'benchmark'

[10000, 100000, 1000000, 10000000].each do |size|
    Benchmark.bm do |b|
	      b.report("chainable #{size}") do
			      hashes = (1..size).select(&:even?).map(&:hash).map(&:to_s)
				      end
     end

	  Benchmark.bm do |b|
		    b.report("one iteration #{size}") do
			        hashes = (1..size).inject([]) do |accumulator, number|
					          if number.even?
								          accumulator << number.hash.to_s
										          else
													          accumulator
															          end
							        end
					    end
			  end

	    Benchmark.bm do |b|
		      b.report("chainable lazy #{size}") do
				      hashes = (1..size).lazy.select(&:even?).map(&:hash).map(&:to_s).to_a
					      end
			    end
end
