-- tg = timing group (i.e. tucky gucky)
-- sg = scroll group

DRAW_DUCKY = true
BUTTON_SIZE = {80, 50}

function draw()
    imgui.PushStyleColor(imgui_col.WindowBg, {0.00, 0.00, 0.00, 1.00})
    imgui.PushStyleColor(imgui_col.TitleBg, {0.00, 0.00, 0.00, 1.00})
    imgui.PushStyleColor(imgui_col.TitleBgActive, {0.00, 0.00, 0.00, 1.00})
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, {0.00, 0.00, 0.00, 1.00})
    imgui.PushStyleColor(imgui_col.Button, {0.16, 0.14, 0.13, 1.00})
    imgui.PushStyleColor(imgui_col.ButtonHovered, {0.26, 0.24, 0.23, 1.00})
    imgui.PushStyleColor(imgui_col.ButtonActive, {0.36, 0.34, 0.33, 1.00})
    imgui.PushStyleColor(imgui_col.Text, {0.85, 0.54, 0.35, 1.00})
    imgui.PushStyleVar(imgui_style_var.ItemSpacing, {4, 4})
    imgui.PushStyleVar(imgui_style_var.WindowPadding, {8, 8})
    imgui.PushStyleVar(imgui_style_var.FramePadding, {8, 8})
    imgui.PushStyleVar(imgui_style_var.WindowRounding, 14)
    imgui.PushStyleVar(imgui_style_var.FrameRounding, 12)
    
    imgui.Begin("tuckygucky", imgui_window_flags.AlwaysAutoResize)
    imgui.Columns(2, " ", false)
    imgui.Text("current: ")
    imgui.Text("selected note: ")
    imgui.NextColumn()
    imgui.Text(state.SelectedScrollGroupId)
    if #state.selectedHitObjects == 1 then imgui.Text(state.selectedHitObjects[1].TimingGroup) end
    imgui.Columns(1)
    
    imgui.Dummy({0, 0})
    imgui.Separator()
    imgui.Dummy({0, 0})
    
    imgui.BeginDisabled(#state.selectedHitObjects == 0)
    -- Turn selected notes into unique timing groups
    if imgui.Button("tg-ify notes", BUTTON_SIZE) then
        local batchActions = {}
        for i, note in ipairs(state.selectedHitObjects) do
            --[[
                Having each single note be in a timing group with the name "StartTime|Lane" allows
                notes to easily reference their own timing group, and timing groups to easily
                reference their own note. This can be useful in SV plugins where you can do
                
                local tgName = state.SelectedScrollGroupId
                local note = map.GetTimingGroupObjects(tgName)[1]
                
                to get note info from the current timing group to use for something
                (after setting the current timing group to a selected note).
            --]]
            local actionType = action_type.CreateTimingGroup
            local tgName = table.concat({note.StartTime, "|", note.Lane})
            local sg = utils.CreateScrollGroup({})
            local sgNotes = {note}
            local action = utils.createEditorAction(actionType, tgName, sg, sgNotes)
            table.insert(batchActions, action)
        end
        actions.PerformBatch(batchActions)
    end
    imgui.EndDisabled()
    imgui.SameLine()
    local oneNoteSelected = #state.selectedHitObjects == 1
    imgui.BeginDisabled(not oneNoteSelected)
    local doTuckyGucky = utils.IsKeyPressed(keys.B) and oneNoteSelected
    -- Set current timing group to selected note's timing group
    if imgui.Button("note tg to\ncurrent tg", BUTTON_SIZE) or doTuckyGucky then
        print("E!", "sex")
        -- Waiting for https://github.com/Quaver/Quaver/pull/4380
        --state.SelectedScrollGroupId = state.selectedHitObjects[1].TimingGroup
    end
    imgui.EndDisabled()
    local winPos = imgui.GetWindowPos()
    imgui.End()
    
    if not DRAW_DUCKY then return end
    
    local o = imgui.GetOverlayDrawList()
    
    -- Head shadow, rgbaToUint(236, 222, 126, 255) = 4286504684
    o.AddCircleFilled({winPos[1] - 27, winPos[2] - 53}, 83, 4286504684)
    
    -- Head bright, rgbaToUint(236, 222, 126, 255) = 4287623679
    o.AddCircleFilled({winPos[1] - 30, winPos[2] - 60}, 75, 4287623679)
    
    -- Hair, rgbaToUint(236, 222, 126, 255) = 4286504684
    o.AddQuadFilled({winPos[1] - 30, winPos[2] - 135},
                    {winPos[1] - 9, winPos[2] - 154},
                    {winPos[1] + 14, winPos[2] - 146},
                    {winPos[1] - 15, winPos[2] - 135}, 4286504684)
    
    -- Eyes dark, rgbaToUint(57, 57, 57, 255) = 4281940281
    o.AddCircleFilled({winPos[1] - 68, winPos[2] - 85}, 20, 4281940281)
    o.AddCircleFilled({winPos[1] - 2, winPos[2] - 85}, 20, 4281940281)
    
    -- Eyes light, rgbaToUint(83, 113, 133, 255) = 4286935379
    o.AddCircleFilled({winPos[1] - 64, winPos[2] - 81}, 15, 4286935379)
    o.AddCircleFilled({winPos[1] - 6, winPos[2] - 81}, 15, 4286935379)
    
    -- Eyes highlight, rgbaToUint(160, 220, 252, 255) = 4294761632
    o.AddCircleFilled({winPos[1] - 76, winPos[2] - 92}, 6, 4294761632)
    o.AddCircleFilled({winPos[1] - 10, winPos[2] - 92}, 6, 4294761632)
    
    -- Beak dark, rgbaToUint(166, 112, 59, 255) = 4282085542
    local p1 = {winPos[1] - 78, winPos[2] - 34}
    local p2 = {winPos[1] - 48, winPos[2] - 27}
    local p3 = {winPos[1] - 48, winPos[2] - 19}
    local p4 = {winPos[1] - 13, winPos[2] - 27}
    local p5 = {winPos[1] - 11, winPos[2] - 19}
    local p6 = {winPos[1] + 11, winPos[2] - 42}
    o.AddTriangleFilled(p1, p2, p3, 4282085542)
    o.AddTriangleFilled(p4, p2, p3, 4282085542)
    o.AddTriangleFilled(p4, p5, p3, 4282085542)
    o.AddTriangleFilled(p4, p5, p6, 4282085542)
    
    -- Beak light, rgbaToUint(230, 158, 86, 255) = 4283866854
    local p7 = {winPos[1] - 33, winPos[2] - 58}
    o.AddTriangleFilled(p1, p2, p7, 4283866854)
    o.AddTriangleFilled(p2, p4, p7, 4283866854)
    o.AddTriangleFilled(p4, p6, p7, 4283866854)
    
    -- Beak highlight, rgbaToUint(230, 196, 86, 255) = 4283876582
    o.AddTriangleFilled({winPos[1] - 70, winPos[2] - 37},
                        {winPos[1] - 49, winPos[2] - 39},
                        {winPos[1] - 34, winPos[2] - 55}, 4283876582)
end