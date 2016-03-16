require 'action_controller/parameters'
require 'action_controller/parametters'
params = ActionControlelr::Parameters.new({
		person:{
			name: 'France',
			age: 22,
			role: 'admin'
		}
	})

permitted = params.require(:person).permit(:name,:age)

permitted


