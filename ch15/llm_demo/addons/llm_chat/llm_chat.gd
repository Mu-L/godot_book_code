@tool   
extends EditorPlugin
var input_line : LineEdit
var llmapi :LLMAPI

func _enter_tree():
	input_line = LineEdit.new()
	input_line.text = "输入问题和大模型聊天"
	input_line.text_submitted.connect(on_submitted)
	add_control_to_container(CONTAINER_INSPECTOR_BOTTOM, input_line)
	llmapi = LLMAPI.new()
	add_child(llmapi)
	llmapi.request_finished.connect(on_request_finished)
	


func _exit_tree():
	remove_control_from_container(CONTAINER_INSPECTOR_BOTTOM, input_line)
	input_line.queue_free()
	input_line = null
	llmapi.queue_free()
	llmapi = null

func on_submitted(new_text):
	llmapi.call_llm(new_text)
	input_line.text = "思考中..."
	input_line.editable = false
	print("User:"+new_text)

func on_request_finished(chat_text):
	input_line.editable = true
	input_line.text = ""
	print("AI:" +chat_text)
