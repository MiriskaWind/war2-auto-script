nLog(os.date("[%X]:", getNetTime()).."关键函数库调用成功！")
--兵种基本信息
arms = {
    --{1:名称,2:时间,3:粮食,4:钢铁,5:石油,6:稀矿,7:生命,8:对空,9:对地,10:对海,11:对防,12"防御,13:射程,14:速度,15:负重,16:耗粮,17:耗油,18:人口,19:图片}
    {"步兵",60,50,70,10,100,100,9,10,10,18,10,20,300,50,1,1,1}, --1
    {"摩托化骑兵",70,100,120,30,50,65,5,12,7,10,8,30,1400,110,2,5,2}, --2
    {"装甲车",90,50,500,150,550,220,24,16,10,14,25,40,450,210,2,25,3}, --3
    {"卡车",150,50,250,50,10,120,5,5,6,10,5,20,1150,1200,2,15,2}, --4
    {"轻型坦克",200,300,750,400,300,160,16,28,22,25,35,55,850,80,4,28,4}, --5
    {"重型坦克",250,500,1200,600,400,235,18,40,28,35,40,65,680,95,7,52,7}, --6
    {"突击炮",180,250,500,300,750,140,22,32,36,55,20,1500,420,50,5,36,5}, --7
    {"火箭",480,450,1800,2700,1800,100,10,80,48,72,20,3300,380,100,12,70,12}, --8
    {"歼击机",210,50,300,500,150,120,32,19,13,9,21,100,2000,100,3,95,4}, --9
    {"轰炸机",240,100,500,800,250,135,25,33,31,22,16,100,1750,28,5,125,6}, --10
    {"特种兵",180,2000,700,600,1500,120,30,60,55,80,5,10,2500,10,10,24,10}, --11
    {"驱逐舰",700,500,2600,1500,900,350,42,65,45,40,45,200,1000,1000,15,400,15}, --12
    {"潜艇",520,300,1800,1300,2000,200,140,18,92,25,30,70,1700,500,14,420,14}, --13
    {"战列舰",4500,2000,27000,11000,14500,1500,73,85,120,110,120,1800,900,2500,40,1200,40}, --14
    {"航母",1000,8500,21000,8000,25000,2200,110,95,100,90,100,3100,850,10000,55,3000,55}, --15
    {"导弹车",1000,4200,8000,12000,8000,500,15,120,140,100,34,3300,650,280,30,60,40}, --16
    {"高炮",1000,4500,10800,6000,5000,1500,88,22,25,20,100,200,800,300,20,45,32}, --17
    {"攻击机",1000,3000,4500,8000,2000,600,28,100,125,80,42,1800,1200,40,18,130,26}, --18
    {"截击机",1000,1000,5500,6000,2500,750,80,25,30,30,45,300,2200,55,15,115,20}, --19
    {"侦察机",1000,50,150,100,50,55,10,5,8,7,8,100,5000,5,1,20,1}, --20
}
function now_wid() --界面判定
    local mian_wid = widget.find({["id"]=bid..":id/game_menu"})
    local map_wid = widget.find({["id"]=bid..":id/map_position_button"})
    if mian_wid ~= nil  then
        if map_wid ~=nil then
            return "地图区"
        else 
            return "军事区"
        end
    else
        local wid,tab = widget.find({["id"]=frontAppBid()..":id/title"})
        if wid ~= nil then
            return tab["text"]
        end
    end
end
function ttap(x,y) --点击后延时
    tap(x,y)
    mSleep(t_delay)
end
function text_click(text)
    local wid = widget.text(text,{["rule"]=1,["which"]=1})
    if wid == nil then
    else
        local x1,y1,x2,y2 = widget.region(wid)
        tap(x1/2+x2/2,y1/2+y2/2)
        mSleep(100)
    end
end
function button_click(id) --控件点击
    local wid =widget.find({["id"]=bid..":id/"..id})
    if wid ~= nil then
        --判断控件是否可以点击
        flag = widget.clickable(wid)
        if flag then
            mSleep(10)    
            widget.click(wid)
        else
            mSleep(10)
            x1,y1,x2,y2 = widget.region(wid)
            if x1 ~= nil then
                ttap((x1+x2)/2,(y1+y2)/2);
            end
        end
    else
        mSleep(10)
        toast("控件未找到",5)
        mSleep(100)    
    end
end
function keepalive(...) --保活判定，自动挂起
    local flag = isFrontApp("com.wistone.war2victory.x7sy")
    if flag == 0 then --判断《二战风云二是否在运行，如果不是切换至前台运行》
        r = switchApp("com.wistone.war2victory.x7sy",true)	--切换到《二战风云2》 
        repeat
            local wid = widget.find({["id"]=bid..":id/exit_button"})
            if wid ~= nil then
                button_click("exit_button")
            end
        until now_wid() ~= "次页面"
        repeat
            button_click("exit_button")
            mSleep(500)
            text_click("地图区")
            mSleep(500)
        until now_wid() == "地图区"
    end

end
function coordinate_find(...) --主城坐标查找
    local wid,tab = widget.find({["id"]=bid..":id/cityinfo_all_cities_sub_text1"})
    num1,num2 = string.find(tab["text"],",")
    x = string.sub(tab["text"],2,num1-1)
    y = string.sub(tab["text"],num1+1,-2)
    return x,y
end
function time_wait(start_x,start_y,end_x,end_y,speed,tech,title) --出征时间计算函数
    return math.floor(30+10^5*math.sqrt((end_x-start_x)^2+(end_y-start_y)^2)/(speed*(1+tech/20+title))/3)
end
function increase(...) --召集人口
    ttap(333,1394) --进入城市
    ttap(1848,747) --点击<召集人口>
    ttap(2417,1393) --进入召集人口页面，点击<召集>
    ttap(2519,48) --关闭召集人口页面
end
function zuobiao(x,y) --从地图区选择坐标进入
    text_click("地图区")
    repeat mSleep(10) until now_wid() == "地图区"
    button_click("map_position_button")
    repeat mSleep(10) until now_wid() == "定位"
    local wid_x = widget.find({["id"]=bid..":id/location_x_edittext"})
    widget.setText(wid_x,x)
    local wid_y = widget.find({["id"]=bid..":id/location_y_edittext"})
    widget.setText(wid_y,y)
    text_click("移动") --点击<移动>
end
--[[
    函数名称：刷野主要程序
    参数1：mode
    参数2：tbl
    参数3：officer
    mode参数为出征模式。tbl参数为兵力配置。officer参数为军官配置。
]]--
function Shuaye(mode,tbl,officer)
    text_click(mode)
    repeat mSleep(10) until now_wid() == mode
    button_click("img_officer_icon") --设置军官
    repeat mSleep(10) until now_wid() == "选择军官"
    text_click("本城编制") --点击本城编制
    if text_click(officer) then
        nLog(os.date("[%X]:", getNetTime()).."无军官可用！")
    else
        text_click(officer)
        repeat mSleep(10) until now_wid() == mode
        frame_wid = widget.find({["id"]=bid..":id/scrollView1"})
        frame_x1,frame_y1,frame_x2,frame_y2 = widget.region(frame_wid) --获取选项框范围
        input_wid = widget.find({["id"]=bid..":id/input_button"})
        input_x1,input_y1,input_x2,input_y2 = widget.region(input_wid) --获取输入框
        local k = #tbl
        repeat
            for j = 1,#tbl,1 do
                arms_wid = widget.find({["text"]=arms[tbl[j][1]][1],["rule"]=1,["which"]=1}) --兵种设置
                arms_x1,arms_y1,arms_x2,arms_y2 = widget.region(arms_wid)
                mSleep(10)
                if arms_y2 < frame_y2 and arms_y1 > frame_y1 then
                    mSleep(10)
                    tap(input_x2/2+input_x1/2,arms_y2*1.5-arms_y1/2)
                    repeat
                        mSleep(10) 
                        local wid,tab = widget.find({["id"]=frontAppBid()..":id/game_alert_title"})
                    until wid ~= nil
                    local wid_et = widget.find({["id"]=bid..":id/et_input"})
                    widget.setText(wid_et,tbl[j][2])
                    text_click("确定")
                    k = k-1
                end
            end
            moveTo(frame_x1+1,frame_y2-10,frame_x1+1,frame_y1+10,{["step"] = 100,["ms"] = 100,["index"] = 1,["stop"] = 1})
            mSleep(10)
        until (k == 0)
        button_click("dialog_map_expedition_bottom_button_execute_command") --点击<袭击>
    end
end
--[[
    函数名：城市坐标调取。
    功能：点击头像进入城市列表，收集城市坐标，创建数组集合并返回。
--]]
function city_collect(...) --城市坐标调取
    repeat mSleep(10) until now_wid() == "地图区" or now_wid() == "军事区"
    button_click("commander_head_view")
    repeat mSleep(10) until now_wid() == "军事档案"
    text_click("城市切换")
    city_coordinate = {} --创建城市坐标数组集合
    for i = 1,6,1 do
        repeat
            mSleep(10)
        until now_wid() == "军事档案"
        local wid = widget.find({["id"]=bid..":id/cityinfo_all_cities_sub_image",["which"]=i})
        local x1,y1,x2,y2 = widget.region(wid)
        if wid ~= nil and i < 5 then
            tap((x1+x2)/2,(y1+y2)/2);
            repeat mSleep(10) until now_wid() == "城市信息"
            table.insert(city_coordinate,{coordinate_find(...)})
        else
            if i == 5 then
                local w,h = getScreenSize()
                moveTo(w*7/8,h/2,w/8,h/2,{["step"] = 200,["ms"] = 1,["index"] = 1,["stop"] = 0})
                mSleep(10)
                local wid = widget.find({["id"]=bid..":id/bg_layout",["which"]=i})
                local x1,y1,x2,y2 = widget.region(wid)
                tap((x1+x2)/2,(y1+y2)/2);
                repeat mSleep(10) until now_wid() == "城市信息"
                table.insert(city_coordinate,{coordinate_find(...)})
            else
                tap((x1+x2)/2,(y1+y2)/2);
                repeat mSleep(10) until now_wid() == "城市信息"
                table.insert(city_coordinate,{coordinate_find(...)})
            end
        end
        mSleep(10)
        button_click("back_button")
        mSleep(10)
    end
    button_click("exit_button")
    for i = 1,#city_coordinate,1 do
        nLog(os.date("[%X]:", getNetTime()).."第"..i.."个城市坐标为:"..city_coordinate[i][1]..","..city_coordinate[i][2])
        mSleep(10)
    end
    return city_coordinate
end
function isNumber(words) --判断字符串是否为纯数字
    if string.len(words) < 1 then
        return false
    end
    for i = 1,string.len(words) do
        if string.byte(string.sub(words,i,i)) < 48 or string.byte(string.sub(words,i,i)) > 57 then
            return false
        end
    end
    return true
end
function Isintable(value,tbl) --判断值是否在数组中
    for k,v in pairs(tbl) do
        if value == v then
            return true
        end
    end
    return false
end
function tableMerge(t1, t2) --并表
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end
--[[
函数名称：数组包含判断
参数1：arr 类型：一维数组
参数2：arr_sum 类型：二维数组
功能介绍：输入参数1,，通过循环遍历，判断一个数组是否包含于另一个二维数组中.如果在，返回true。
]]--
function Inarr(arr,arr_sum) 
    for i in pairs(arr_sum) do
        local n = 0
        for j in pairs(arr) do
            if arr[j] == arr_sum[i][j] then
                n = n + 1
            end
        end
        if n == 3 then
            return true
        end
    end
end