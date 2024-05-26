class SqlParser
rule
  sql: select_clause from_clause join_clauses { result = val.compact }
  select_clause: select identifiers { result = val }
  from_clause: from identifiers { result = val }
  join_clauses:
              | join_clause { result = val }
              | join_clause join_clauses { result = val }
  join_clause:
             | join identifier on conditions { result = val }
  where_clause:
              | where conditions { result = val }
  identifiers: identifier
             | identifier punctuation identifiers { result = val }
  conditions: condition
            | condition and_or conditions { result = val }
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
  pp @q
  
  do_parse
end

def next_token
  @q.shift
end

---- footer

if __FILE__ == $0
  begin
    sql =<<-SQL
      select aaa from bbb
    SQL
    ast = SqlParser.new.parse('select a from b, c, d')
    pp ast
  rescue Racc::ParseError => e
    $stderr.puts e
    $stderr.puts e.backtrace
  end
end

