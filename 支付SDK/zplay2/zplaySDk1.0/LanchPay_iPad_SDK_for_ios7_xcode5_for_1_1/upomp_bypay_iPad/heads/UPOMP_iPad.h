
#import <UIKit/UIKit.h>

@protocol UPOMP_iPad_Delegate<NSObject>
@required
-(void)viewClose:(NSData*)data;
@end

@interface UPOMP_iPad : UIViewController{
	
}
- (void)setXmlData:(NSData*)data;
- (void)closeView:(NSData*)data;
@property (nonatomic, assign) id <UPOMP_iPad_Delegate> viewDelegate;
@end
