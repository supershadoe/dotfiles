--
-- Clip video script
-- Origin unknown
-- Fixed by supershadoe
-- mpv script to clip videos using ffmpeg quickly
--

local msg = require "mp.msg"
local utils = require "mp.utils"
local overlay = mp.create_osd_overlay("ass-events")

local start_time = 0
local end_time = mp.get_property_number("duration")

local start_time_f = "00:00:00"
local end_time_f = mp.command_native({"expand-text","${duration}"})

local clip_mode = false

local cmd_args = ""

function clip_video()
  local ip_path = mp.get_property("path")

  local op_dir, _ = utils.split_path(ip_path)
  local op_ext = mp.get_property("filename"):match("[^.]+$")
  local op_name = string.format(
    "%s_%s-%s.%s",
    mp.get_property("filename/no-ext"),
    string.gsub(start_time_f, ":", "."),
    string.gsub(end_time_f, ":", "."),
    op_ext)
  local op_path = utils.join_path(op_dir, op_name)

  local command = {
    "/usr/bin/ffmpeg", "-hide_banner", "-loglevel", "error",
    "-ss", tostring(start_time),
    "-i", tostring(ip_path),
    "-t", tostring(end_time-start_time)
  }
  for token in string.gmatch(cmd_args, "[^%s]+") do
    table.insert(command, token)
  end
  table.insert(command, op_path)

  overlay.data = "Clipping.."
  msg.info("Clipping the video...")
  overlay:update()

  local r = mp.command_native({
    name = "subprocess",
    playback_only = false,
    capture_stdout = true,
    detach = false,
    args = command,
  })

  msg.info("Clipped and saved!")
  reset_pos(true)
  reset_pos(false)
end

function set_pos(start)
  duration = mp.get_property_number("time-pos")
  duration_f = mp.command_native({"expand-text", "${time-pos}"})
  if start then
    start_time = duration
    start_time_f = duration_f
  else
    end_time = duration
    end_time_f = duration_f
  end
  msg.debug(string.format("%s - %s set", start_time_f, end_time_f))
  refresh_ov()
end

function reset_pos(start)
  start_time = start and 0 or start_time
  start_time_f = start and "00:00:00" or start_time_f
  end_time = not start and mp.get_property_number("duration") or end_time
  end_time_f = not start and mp.command_native({"expand-text", "${duration}"}) or end_time_f
  refresh_ov()
end

function refresh_ov()
  local st = "{\\1c&HFF00FF&}"
  overlay.data = string.format(
      "%s--------------\n%s| Clip Mode |\n%s--------------\n%sStart pos: %s\n%sEnd pos: %s", st, st, st, st, start_time_f, st, end_time_f)
  overlay:update()
end

function override_keybinds()
  mp.add_forced_key_binding("-", "set_start", function() set_pos(true) end, {repeatable = true})
  mp.add_forced_key_binding("=", "set_end", function() set_pos(false) end, {repeatable = true})
  mp.add_forced_key_binding("BS", "reset_start", function() reset_pos(true) end, {repeatable = true})
  mp.add_forced_key_binding("Shift+BS", "reset_end", function() reset_pos(false) end, {repeatable = true})
  mp.add_forced_key_binding("ENTER", "finalize", function() clip_video() end, {repeatable = true})
  mp.add_forced_key_binding("ESC", "quit-clip", function() toggle_clip_mode() end, {})
end

function undo_keybinds()
  mp.remove_key_binding("set_start")
  mp.remove_key_binding("set_end")
  mp.remove_key_binding("reset_start")
  mp.remove_key_binding("reset_end")
  mp.remove_key_binding("finalize")
  mp.remove_key_binding("quit-clip")
end

function toggle_clip_mode(p_cmd_args)
  reset_pos(true)
  reset_pos(false)
  if not clip_mode then
    clip_mode = true

    cmd_args = p_cmd_args and utils.to_string(p_cmd_args) or '-c copy'

    override_keybinds()
    msg.info("Entered clip mode")
    refresh_ov()
  else
    clip_mode = false
    undo_keybinds()
    msg.info("Exited clip mode")
    overlay:remove()
  end
end

mp.register_script_message('clip-video', toggle_clip_mode)
