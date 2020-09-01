
require 'pg'

class DatabasePersistence
  def initialize(logger) # sinatra logger object passed as an argument for logging
    @db = PG.connect(dbname: 'todos') # 
    @logger = logger # see https://launchschool.com/lessons/421e2d1e/assignments/d7a23509
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)  # the * splat operator in the parameter implementation 2 lines above turns `params` in this line into an array of such arguments
  end

  def find_list(id)
    sql = "SELECT * from lists where id = $1" # the $1 here being the id argument passed in to this find_list(id) method
    result = query(sql, id) # takes the parameter id, and this array will be used to fill the sql query, in this case only $1 
    tuple = result.first # we only need the first row
    {id: tuple['id'], name: tuple['name'], todos: []}  # already was built in all_lists method in this file
  end

  def all_lists
    sql = "SELECT * from lists" # note the ; is optional and is appended for you if you do not include it
    result = query(sql) # note our `query` method now handles logging too, see it's implementation
    result.map do |tuple| # take each record/row and conver them into a hash, each of which togther are returned in an array by .map
      {id: tuple['id'], name: tuple['name'], todos: []}
    end
  end

  def create_new_list(list_name)
    # id = next_element_id(@session[:lists]) # for assigning an :id to a list, a new feature at this point, Lesson 6: https://launchschool.com/lessons/2c69904e/assignments/a8c93890
    # @session[:lists] << { id: id, name: list_name, todos: [] } # remember in our form the <input> tag had a `name` of "list_name", so this is the key, and the value is whatever data we submitted if any, not there yet at this point, and note "list_name" can simply be treated as a symbol by sinatra, so :list_name in params hash
  end

  def delete_list(list_id)
    # @session[:lists].reject! {|list| list[:id] == list_id } # remove the list - which is a hash itself, from the session array. refactored in lesson 6 to use Array#reject! and an actual id not based on index, for the list: https://launchschool.com/lessons/2c69904e/assignments/a8c93890
  end

  def update_list_name(list_id, new_name)
    # list = find_list(list_id)
    # list[:name] = new_name
  end

  def create_new_todo(list_id, todo_name) # adding a new todo item to a list
    # list = find_list(list_id)
    # id = next_element_id(list[:todos]) # assign an id to the new todo item, Lesson 6 assignment: https://launchschool.com/lessons/9230c94c/assignments/046ee3e0, refactored to general method for lists and ids in next assignment: https://launchschool.com/lessons/2c69904e/assignments/a8c93890
    # list[:todos] << { id: id, name: todo_name, completed: false } # params[:todo] is the submitted text taken from form submission at the list.erb page submit form for a todo item, which is named "todo"
  end

  def delete_todo_from_list(list_id, todo_id)
    # list = find_list(list_id)
    # list[:todos].reject! {|todo| todo[:id] == todo_id }  # updated Lesson 6, for any existing todo item with an id equal to todo_id `:id` from the url params, delete from todos with Array#reject!, https://launchschool.com/lessons/2c69904e/assignments/af479b47
  end

  def update_todo_status(list_id, todo_id, new_status)
    # list = find_list(list_id)
    # todo =  list[:todos].find {|t| t[:id] == todo_id } # refactored in lesson 6 assignment https://launchschool.com/lessons/2c69904e/assignments/af479b47
    # todo[:completed] = new_status
  end

  def mark_all_todos_as_completed(list_id)
    # list = find_list(list_id)
    # list[:todos].each { |todo| todo[:completed] = true }
  end
end