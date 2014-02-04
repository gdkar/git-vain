require 'digest/sha1'

MSG = 'dead'
base = `git cat-file -p HEAD`

def parse_commit(original)
  parts = original.split(/(^author.*> |committer.*> )(\d+)(.*$)/, 3)
  [ parts[0..1].join,
    parts[2   ].to_i,
    parts[3..5].join,
    parts[6   ].to_i,
    parts[7..-1].join ]
end

@head, @t_author, @middle, @t_committer, @rest = parse_commit(base)

def search
  counter = 0
  (0..3600).each do |c|
  [c*1,c*-1].uniq.each do |co|
    comm_t = @t_committer+co
  (0..3600).each do |a|
  [a*1,a*-1].uniq.each do |ao|
    auth_t = @t_author+ao
  #(0..80  ).each do |space|
    content = [@head, auth_t, @middle, comm_t, @rest].join
    store = "commit #{content.length}\0" + content
    sha1 = Digest::SHA1.hexdigest(store)

    if sha1[0..3] == MSG
      puts "comm_t: #{co} auth_t: #{ao} counter: #{counter}"
      return [content,sha1]
    end

    counter+=1
    puts counter if (counter%100000).zero?
  #end
  end
  end
  end
  end
end

content, sha1 = search()

File.open("/tmp/commit", 'w') {|f| f.write(content) }
sha2=`git hash-object -t commit /tmp/commit`.strip

if sha1==sha2
  system("git reset --soft HEAD^")
  system("git hash-object -t commit -w /tmp/commit")
  system("git reset --soft #{sha1}")
else
  puts "failed, git doesn't agree:"
  puts sha1
  puts sha2
end
