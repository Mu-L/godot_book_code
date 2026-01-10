extends HTTPRequest
class_name LLMAPI

signal  request_finished

var output: String
var history: Array = []
var history_count: int = 3
var api_key :String = ""
var header :Array
var url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions"
var model_name = "qwen-max"
var cfg_path = "res://config/api_config.cfg"
var system_prompt: String = "你是一个精通游戏设计和Godot游戏开发的智能助手，你的回答字数不超过200个字"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_api_key()
	header = ["Authorization: Bearer " + api_key, "Content-Type: application/json"]
	request_completed.connect(on_request_completed)

	
func call_llm(prompt):
	var new_message = {"role": "user", "content": prompt} 
	history.append(new_message)
	var sys_message = {"role": "system", "content": system_prompt}
	var messages = [sys_message]
	messages.append_array(history.slice(-history_count))
	
	var body = JSON.stringify({
		"model": model_name,
		"messages" : messages,
		"stream" : false
	})
	var request_result = request(url,
								header,
								HTTPClient.METHOD_POST,
								body)
	if request_result != OK:
		push_error("LLM 请求失败，错误码：%s" % request_result)



func on_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	output = response['choices'][0].message.content
	history.append({"role": "assistant", "content":output})
	request_finished.emit(output)

func load_api_key():
	var config := ConfigFile.new()
	var err := config.load(cfg_path)
	if err == OK:
		api_key = config.get_value("api", "key", "")
	else:
		push_error("无法加载 API 密钥配置文件")
