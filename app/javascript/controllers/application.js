import { Application } from "@hotwired/stimulus"
import NavbarController from "./navbar_controller"
import ArrowController from "./arrow_controller"
import HomeController from "./home_controller"
import FlatpickrController from "./flatpickr_controller"
import MapController from "./map_controller"
import NewPlanController from "./new_plan_controller"
import ShowPlanController from "./show_plan_controller"
import AllMyPlansController from "./all_my_plans_controller"
import ProfileController from "./profile_controller"
import AutocompleteAddressController from "./autocomplete_address_controller"
import NewReviewController from "./new_review_controller"
import EditReviewController from "./edit_review_controller"
import TravelsFiltersController from "./travels_filters_controller";
import RegisterController from "./register_controller";

const application = Application.start()
application.register('navbar', NavbarController)
application.register('scroll', ArrowController)
application.register('home', HomeController)
application.register('flatpickr', FlatpickrController)
application.register('map-filter', MapController)
application.register('new-plan', NewPlanController)
application.register('show-plan', ShowPlanController)
application.register('my-plans', AllMyPlansController)
application.register('profile', ProfileController)
application.register('autocomplete-address', AutocompleteAddressController)
application.register('new-review', NewReviewController)
application.register('edit-review', EditReviewController)
application.register('travels-filters', TravelsFiltersController)
application.register('register', RegisterController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
