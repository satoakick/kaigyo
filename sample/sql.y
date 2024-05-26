class SqlParser
rule
  sql: select_and_from semi_colon_char { result = val.compact }
     | select_and_from optional_clauses semi_colon_char { result = val.compact }

  optional_clauses: 
       join_clauses { result = val }
     | where_clause { result = val }
     | group_by_clause { result = val }
     | order_by_clause { result = val }
     | join_clauses optional_clauses { result = val }
     | where_clause optional_clauses { result = val }
     | group_by_clause optional_clauses { result = val }
     | order_by_clause optional_clauses { result = val }
     | limit_clause { result = val }

  select_and_from: 
    select_clause from_clause { result = val }
    | select_clause { result = val }
  select_clause: select idents { result = val }
  from_clause:
    from idents { result = val }

  join_clauses: join_clause { result = val }
              | join_clause join_clauses { result = val }
  join_clause: join ident on conditions { result = val }
             | join ident on conditions as identifier { result = val }
  idents: ident
        | ident punctuation idents { result = val }
        | left_paren sql right_paren { result = val }
        | left_paren sql right_paren as ident { result = val }
        | number
        | literal
  ident: identifier
       | identifier as identifier { result = val }      
  
  conditions: condition
            | condition and_or conditions { result = val }
  condition: ident operator number { result = val }
           | ident operator literal { result = val }
           | ident operator ident { result = val }
  and_or: and | or
  operator: equal | less_than | less_than_equal | greater_than | greater_than_equal
  where_clause: where conditions { result = val }
  group_by_clause: group_by idents { result = val }
  order_by_clause: order_by order_by_idents { result = val }
  order_by_idents: order_by_ident { result = val }
                  | order_by_ident punctuation order_by_idents { result = val }
  order_by_ident: ident { result = val }
                | ident order_option { result = val }
  limit_clause: limit number { result = val }
  semi_colon_char:
            | semi_colon { result = val }
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
TEST_SQL =<<-SQL
  select a as aa , b as bb, (select c from hoge where c.id = 1 or hoge.id = 1) as cc inner join piyo as p on p.id = a.id left outer join aaaaa as aaa on aaa.id = a.id where aaa.gid > 1 or aaa.id > 0;
SQL
  begin
    puts '> Please input SQL'
    sql = gets.chomp
    # ast = SqlParser.new.parse(TEST_SQL)
    parsed = SqlParser.new.parse(sql)
    puts "AST:"
    pp parsed
  rescue Racc::ParseError => e
    $stderr.puts e
    $stderr.puts e.backtrace
  end
end

