// simple web-app in vlang that holds number of requests made since start-up
// run as:
//	 	v run web_counter.v
// cerner_2tothe5th_2022
import vweb
import sqlite

struct App {
	vweb.Context
pub mut:
	db sqlite.DB
}

// ORM Counter, the agent could hold user-agent perhaps
struct Counter { id int [primary; sql: serial] agent string }

// start the webserver with in-memory sqlite, this could be persisted as well..
fn main() {
	mut app := App { db: sqlite.connect(':memory:') or { panic(err) } }
	sql app.db { create table Counter }
	vweb.run(app, 8081) // starts server at localhost:8081
}

// get current hits, vlang expects function names to be snake_case
pub fn (app &App) get_counter() int {
	return sql app.db { select count from Counter}
}

// define the index route
['/index']
pub fn (mut app App) index() vweb.Result {
	counter := Counter { agent: app.req.header.get(.user_agent) or { "unknown-agent"} } // TODO: store into agent column so that we can group by this
	sql app.db { insert counter into Counter } // increment the counter
	message := app.get_counter() // this variable is accessible in the web layer
	return $vweb.html() // loads the index.html 
}
