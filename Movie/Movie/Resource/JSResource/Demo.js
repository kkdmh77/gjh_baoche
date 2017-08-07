require('UITableView, UITableViewCell, UIColor');
require('JPEngine').addExtensions(['JPInclude']);
require('LearningBookHomePageVC, UIAlertView');

include('CommonDefine.js');

var tableCellHeight = 70;
var cellIdentifier = "cell";

/*
defineClass('ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>', {
    viewDidLoad: function() {
        self.super().viewDidLoad();
        
        self.setDataArray(["第一个bug（点一下就会崩溃，不信试试看）", "第一个bug（点一下就会崩溃，不信试试看）", "第一个bug（点一下就会崩溃，不信试试看）"]);
            
        var table = UITableView.alloc().initWithFrame_style(self.view().bounds(), 0);
        // var table = UITableView.alloc().initWithFrame_style({x:0, y:0, width:SCREEN_WIDTH, height:250}, 0);
        table.setDataSource(self);
        table.setDelegate(self);
        table.setAutoresizingMask(1 << 1 | 1 << 4);
        table.setBackgroundColor(UIColor.greenColor());
        self.view().addSubview(table);
    },
    
    tableView_numberOfRowsInSection: function(tableView, section) {
        return self.dataArray().count();
    },
            
    tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
        return tableCellHeight;
    },
    
    tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier);
        if (!cell) {
            cell = UITableViewCell.alloc().initWithStyle_reuseIdentifier(0, cellIdentifier);
        }
        cell.textLabel().setText(self.dataArray().objectAtIndex(indexPath.row()));
        
        return cell;
    },
            
    tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
        // self.cellSelectedWithIndexPath(indexPath);
        var ctrl = JPDemoController.alloc().init();
        self.navigationController().pushViewController_animated(ctrl, YES);
    }
})
*/

defineClass('LearningBookHomePageVC', {
    viewDidLoad: function() {
        self.ORIGviewDidLoad();
        self.setTitle('文虎好帅');
    }
})
