# server.rb
require 'rubygems'
require 'sinatra'
require "sinatra/namespace"
require 'mongoid'
require 'byebug'

# DB Setup
Mongoid.load! "mongoid.config"

# Models
class Bird
	include Mongoid::Document
	
	field :schema,               type: String
	field :title,                type: String
	field :description,          type: String
	field :type,                 type: String
	field :required,             type: Array,    default: []
	field :additionalProperties, type: Boolean
	field :properties,           type: Hash,     default: {}
	field :visible,              type: Hash,     default: { type: false, description: "" }
	field :added,                type: Hash,     default: { type: "String", description: Date.today }

	#index({title: 'text'})
	validates :title,       presence: true
	validates :type,        presence: true
	validates :description, presence: true
end

# Serializers
class BirdSerializer
	
	def initialize(bird)
		@bird = bird
	end
	
	def as_json(*)
		data = {
			schema: @bird.schema,
			title: @bird.title,
			description: @bird.description,
			type: @bird.type,
			additionalProperties: @bird.additionalProperties,
			items: {
				type: "string",
				description: @bird.id.to_s,
				uniqueItems: @bird.properties[:continents][:uniqueItems]
			}
		}
		data[:errors] = @bird.errors if @bird.errors.any?
		data
	end
end


namespace '/api/v1' do
	
	before do
		content_type 'application/json'
	end
	
	helpers do
		def base_url
			@base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
		end
		
		def json_params
			begin
				JSON.parse(request.body.read)
			rescue
				halt 400, {message: 'Invalid JSON',status: 404}.to_json
			end
		end
		
		def bird
			@bird ||= Bird.where(id: params[:id]).first
		end
		
		def halt_if_not_found!
			halt(404, {message: 'Bird Not Found',status: 404}.to_json) unless bird
		end
		
		def serialize(bird)
			data = {}
			unless bird.errors.any?
				data = {
					schema:               bird.schema,
					title:                bird.title,
					description:          bird.description,
					type:                 bird.type,
					required:             bird.required,
					additionalProperties: bird.additionalProperties,
					properties:           bird.properties,
					added:                bird.added,
					visible:              bird.visible
				}
				data[:properties][:id] = { type: "string", description: bird.id.to_s }
				data[:required]  << "id" << "added" << "visible"
				data[:status] = 200
				data.to_json
			else
				data[:errors] = bird.errors
				data[:status] = 400
				data[:message] = "Invalid JSON"
				data.to_json 
			end
			
		end
	end
	
	# Endpoints
	
	get "/birds" do
		birds = Bird.all
		birds.map { |bird| BirdSerializer.new(bird) }.to_json
	end
	
	get '/birds/:id' do |id|
		halt_if_not_found!
		serialize(bird)
	end
	
	post '/birds' do
		bird =  Bird.new(json_params)
		if bird.save
			serialize(bird)
		else	
			halt 400, serialize(bird) 
		end
	end
	
	delete '/birds/:id' do |id|
		halt_if_not_found!
		bird.destroy if bird
		{ message: 'Bird has been deleted Successfully!', status: 200 }.to_json
	end

end