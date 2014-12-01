//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// See: http://bit.ly/hS5nNh for unit test macros.

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "NINetworkActivity.h"

@interface NINetworkActivityTests : SenTestCase
@end


@implementation NINetworkActivityTests


- (void)testNetworkActivity {
  STAssertFalse([UIApplication sharedApplication].networkActivityIndicatorVisible,
                @"Activity indicator should be hidden.");

  // TODO (Jan 26, 2012): Swizzle out the networkActivityIndicatorVisible method so that we can
  // test when it gets changed.
}

@end