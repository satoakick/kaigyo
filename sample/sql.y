class SqlParser
rule
  sql: select_clause from_clause join_clauses where_clause { result = val.compact }
  select_clause: select identifiers { result = val }
  from_clause: from identifiers { result = val }
  join_clauses:
              | join_clause { result = val }
              | join_clauses join_clause { result = val }
  join_clause:
             | join identifier on conditions { result = val }
  group_clause:
              | group_by identifier { result = val }
  identifiers: identifier
             | identifiers punctuation identifier { result = val }
  where_clause:
              | where conditions { result = val }
  conditions: condition
            | conditions and_or condition { result = val }
  condition: identifier operator number { result = val }
           | identifier operator identifier { result = val }
  and_or: and | or
  operator: equal | less_than | less_than_equal | greater_than | greater_than_equal
end

---- header
#
---- inner

load '../lib/kaigyo/tokenizer.rb'
def parse(str)
  tokenizer = ::Kaigyo::Tokenizer.new(str)
  @q = tokenizer.token_analysis
  @q << [false, '$']
  pp @q
  #@q = [[:item,1],[false,'$']]
  
  do_parse
end

def next_token
  @q.shift
end

---- footer

if __FILE__ == $0
  begin
#str = gets.strip
    sql =<<-SQL
      select aaa from bbb
        left outer join ccc on aaa.id=ccc.id
        inner join ddd on ccc.id = ddd.id
      group by hoge.id
    SQL
    sql =<<-SQL
      select aaa from bbb
    SQL
#where aaa.id=1 or bbb.id=2
    ast = SqlParser.new.parse(sql)
    pp ast
  rescue Racc::ParseError => e
    $stderr.puts e
    $stderr.puts e.backtrace
  end
end

