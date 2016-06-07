require "hypernova/blank_renderer"

class Hypernova::BatchRenderer
  def initialize(jobs)
    @jobs = jobs
  end

  # Sample response argument:
  # {
  #   "DeathStarLaserComponent.js" => {
  #     "duration" => 17,
  #     "error" => nil,
  #     "html" => "<h1>Hello World</h1>",
  #     "statusCode" => 200,
  #     "success" => true,
  #   },
  #   "IonCannon.js" => {
  #     "duration" => 7,
  #     "error" => {
  #       "stack" => [
  #         "no_plans",
  #         "not_enough_resources",
  #       ],
  #     },
  #     "html" => blank_html_rendered_by_blank_renderer,
  #     "statusCode" => 500,
  #     "success" => false,
  #   },
  # }

  # Example of what is returned by this method:
  # {
  #   "DeathStarLaserComponent.js" => "<h1>Hello World</h1>",
  #   "IonCannon.js" => <p>Feel my power!</p>,
  # }
  def render(response)
    response.each_with_object({}) do |array, hash|
      name_of_component = array[0]
      hash[name_of_component] = extract_html_from_result(name_of_component, array[1])
    end
  end

  # Example of what is returned by this method:
  # {
  #   "DeathStarLaserComponent.js" => <div>I am blank</div>,
  #   "IonCannon.js" => <div>I am blank</div>,
  # }
  def render_blank
    hash = {}
    jobs.each { |name_of_component, job| hash[name_of_component] = render_blank_html(job) }
    hash
  end

  private

  attr_reader :jobs

  def extract_html_from_result(name_of_component, result)
    result["html"].nil? ? render_blank_html(jobs[name_of_component]) : result["html"]
  end

  def render_blank_html(job)
    Hypernova::BlankRenderer.new(job).render
  end
end
