# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :digital_ocean,
# use_api_paging: allow the Enumerable implementation to refer to the
# next page parameter in the result to call back to D.O. for more
# results.  Doing so will result in slower Enum methods and will chew
# through allowed requests.  
use_api_paging: false,

# per_page_results: the number of results to return when requesting
# the full list of actions.
actions_per_page: 100
