<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>初心如炬 - 排序游戏</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", sans-serif;
            -webkit-touch-callout: none;
            -webkit-user-select: none;
            user-select: none;
        }

        body {
            background-color: #f5f7fa;
            padding: 20px 15px;
            max-width: 800px;
            margin: 0 auto;
        }

        .title {
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .rule {
            text-align: center;
            margin-bottom: 25px;
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }

        .container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .draggable {
            background: white;
            padding: 14px 16px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            cursor: grab;
            transition: all 0.2s ease;
            border-left: 5px solid #3498db;
            font-size: 15px;
            line-height: 1.5;
            touch-action: none;
        }

        .draggable.dragging {
            opacity: 0.5;
            transform: scale(1.01);
        }

        .check-btn {
            margin: 25px auto;
            padding: 12px 28px;
            background: #2ecc71;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            display: block;
        }

        .result {
            text-align: center;
            font-size: 17px;
            font-weight: bold;
            margin-top: 15px;
        }

        .success {
            color: #27ae60;
        }

        .fail {
            color: #e74c3c;
        }
    </style>
</head>
<body>
    <div class="title">四、初心如炬：以青春之力托举强国梦</div>
    <div class="rule">
        游戏规则：<br>
        1. 鼠标/长按拖动段落排序<br>
        2. 排好后点击【检查答案】
    </div>

    <div class="container" id="container"></div>
    <button class="check-btn" onclick="checkAnswer()">检查答案</button>
    <div class="result" id="result"></div>

    <script>
        // 一句一段 · 原文一字不差
        const data = [
            { id: 1, text: "四、初心如炬：以青春之力托举强国梦" },
            { id: 2, text: "秭归抽蓄团队，平均年龄只有34岁，一大批和我一样的00后、90后，在平凡岗位上书写不凡。有的同事常年驻守工地，舍小家顾大家；有的同事顶烈日、冒风雨，日夜坚守施工一线。" },
            { id: 3, text: "我们半年干了一年半的活，一年干了三年的进度，刷新了抽蓄行业最快的项目筹备、工程筹建、工程推进记录，把无数“不可能”变成了“一定行”。我们用行动证明：重大工程建设没有旁观者，每个岗位都是主角；每一份坚守，都在为实现使命担当添砖加瓦。" },
            { id: 4, text: "等到2030年首台机组投产发电，我们将成功攻克“高水头大容量冲击式机组”这一世界级难题，为攀登人类水电史上的“珠穆朗玛峰”提供最硬核的支撑；秭归抽蓄将并入湖北电网，承担起调峰、填谷、储能等功能，为华中地区提供源源不断的清洁能源，真正走进千家万户的生活。" },
            { id: 5, text: "百年五四，薪火相传，变的是时空，不变的是初心。我们00后生在红旗下，长在春风里，生逢盛世，更重任在肩。请党放心，强国有我！" }
        ];

        // 正确顺序
        const correctOrder = [1,2,3,4,5];
        let list = [...data].sort(() => Math.random() - 0.5);
        const container = document.getElementById("container");
        const result = document.getElementById("result");

        // 渲染页面
        function render() {
            container.innerHTML = "";
            list.forEach((item, index) => {
                const div = document.createElement("div");
                div.className = "draggable";
                div.dataset.index = index;
                div.innerText = item.text;
                container.appendChild(div);
            });
            initDrag();
        }

        // 电脑 + 手机 双端拖拽
        function initDrag() {
            const items = document.querySelectorAll(".draggable");
            let dragIndex = null;

            items.forEach(item => {
                // 电脑端
                item.ondragstart = (e) => {
                    dragIndex = parseInt(item.dataset.index);
                    item.classList.add("dragging");
                };
                item.ondragover = (e) => e.preventDefault();
                item.ondrop = (e) => {
                    e.preventDefault();
                    const dropIndex = parseInt(item.dataset.index);
                    if (dragIndex !== dropIndex) {
                        const moved = list.splice(dragIndex, 1);
                        list.splice(dropIndex, 0, ...moved);
                        render();
                    }
                };
                item.ondragend = () => item.classList.remove("dragging");

                // 手机端
                item.ontouchstart = (e) => {
                    e.preventDefault();
                    dragIndex = parseInt(item.dataset.index);
                    item.classList.add("dragging");
                };
                item.ontouchmove = (e) => e.preventDefault();
                item.ontouchend = (e) => {
                    e.preventDefault();
                    const touch = e.changedTouches[0];
                    const target = document.elementFromPoint(touch.clientX, touch.clientY);
                    if (target && target.classList.contains("draggable")) {
                        const dropIndex = parseInt(target.dataset.index);
                        if (dragIndex !== dropIndex) {
                            const moved = list.splice(dragIndex, 1);
                            list.splice(dropIndex, 0, ...moved);
                        }
                    }
                    item.classList.remove("dragging");
                    render();
                };
            });
        }

        // 检查答案
        function checkAnswer() {
            const userOrder = list.map(item => item.id);
            const isCorrect = JSON.stringify(userOrder) === JSON.stringify(correctOrder);
            
            if (isCorrect) {
                result.className = "result success";
                result.innerText = "✅ 排序完全正确！";
            } else {
                result.className = "result fail";
                result.innerText = "❌ 顺序不对，再调整一下吧～";
            }
        }

        render();
    </script>
</body>
</html>
