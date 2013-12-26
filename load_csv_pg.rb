require 'sequel'
require 'CSV'
require 'trollop'

opts = Trollop.options do 
  opt :csv, "csv file", type: :string, required: true
  opt :db, "database", type: :string, required: true
  opt :host, "database", default: 'localhost'
  opt :user, "user", type: :string, required: true
  opt :table, "table", type: :string, required: true
  opt :replace, "replace existing table"
  opt :append, "append data to existing table"
end

csv = CSV.table(opts[:csv])

db = Sequel.postgres(host: opts[:host],
                     user: opts[:user],
                     password: opts[:password],
                     database: opts[:db])

def create_table(db, table, headers, opts)
  table = table.to_sym
  
  # TODO: verify matching columns on extant table
  unless opts[:append]
    if opts[:replace]
      db.drop_table?(table)
    end
    db.create_table(table) do
      headers.each do |col|
        # TODO: infer column type
        String col
      end
    end
  end

  db[table]
end

tbl = create_table(db, opts[:table], csv.headers, opts)
tbl.import(csv.headers, 
           csv.entries.map { |e| e.to_hash.values })
