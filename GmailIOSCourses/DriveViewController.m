//
//  DriveViewController.m
//  GmailIOSCourses
//
//  Created by Aleksey Drachyov on 5/3/18.
//  Copyright © 2018 Aleksey Drachyov. All rights reserved.
//

#import "DriveViewController.h"
#import <Google/SignIn.h>
#import <GTLRDrive.h>
#import <GTMSessionFetcher/GTMSessionFetcherService.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>
#import "DriveTableViewCell.h"
#import "LoadingViewController.h"
#import "WebLinkViewController.h"

@interface DriveViewController ()<UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GTLRDriveService *driveService;
@property (nonatomic, strong) NSMutableArray<GTLRDrive_File *> *files;
@property (nonatomic, weak) id<LGSideMenuDelegate> delegate;
@end

@implementation DriveViewController {
    GTLRDrive_FileList *_fileList;
    GTLRServiceTicket *_fileListTicket;
    GTLRServiceTicket *_uploadFileTicket;
    GTLRServiceTicket *_editFileListTicket;
}

- (instancetype)initWithService:(GTLRDriveService *)service delegate:(id<LGSideMenuDelegate>)delegate {
    self = [super init];
    if (self) {
        self.driveService = service;
        self.delegate = delegate;
    }
    return self;
}

+ (instancetype)controllerWithService:(GTLRDriveService *)service delegate:(id<LGSideMenuDelegate>)delegate {
    return [[self alloc] initWithService:service delegate:delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"Drive";
    UINib *cellNib = [UINib nibWithNibName:@"DriveTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"driveCell"];
    [self setupNavigationItem];
    [self fetchFileList];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(1, 1);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:141.0/255.0 green:182/255.0 blue:0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:126/255.0 green:167/255.0 blue:0/255.0 alpha:1.0] CGColor], nil];
    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStyleDone target:self.delegate action:@selector(showLeftView)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DriveTableViewCell *cell = (DriveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"driveCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GTLRDrive_File *file = self.files[indexPath.row];
    cell.fileNameLabel.text = file.name;
    [cell setRemoveButtonHidden:!file.ownedByMe.boolValue];
    cell.removeAction = ^{
        [self showDeleteAlertForFile:file];
    };
    return cell;
}

- (void)showDeleteAlertForFile:(GTLRDrive_File *)file {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Do you want to delete file?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSelectedFile:file];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showWebViewWithUrl:[NSURL URLWithString:self.files[indexPath.row].webViewLink]];
}

- (void)showWebViewWithUrl:(NSURL *)url {
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    WebLinkViewController *viewController = [WebLinkViewController controllerWithRequest:req];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)fetchFileList {
    _fileList = nil;
    GTLRDriveService *service = self.driveService;
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.fields = @"kind,nextPageToken, files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed, ownedByMe)";
    
    _fileListTicket = [service executeQuery:query
                          completionHandler:^(GTLRServiceTicket *callbackTicket,
                                              GTLRDrive_FileList *fileList,
                                              NSError *callbackError) {
                              // Callback
                              self->_fileList = fileList;
                              self->_files = fileList.files.mutableCopy;
                              [self sortDocuments];
                              [UIView animateWithDuration:0 animations:^{
                                  [self->_tableView reloadData];
                              } completion:^(BOOL finished) {
                                  [self hideLoading:[LoadingViewController sharedInstance]];
                              }];
                          }];
}

- (void)sortDocuments {
    [self.files sortUsingComparator:^NSComparisonResult(GTLRDrive_File *obj1, GTLRDrive_File *obj2) {
        return [obj2.ownedByMe compare:obj1.ownedByMe];
    }];
}

- (IBAction)uploadButtonPressed:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showLoading:[LoadingViewController sharedInstance] containerView:self.view];
    [self uploadFileAtPath:url.absoluteString];
}

- (void)uploadFileAtPath:(NSString *)path {
    NSURL *fileToUploadURL = [NSURL fileURLWithPath:path];
    NSError *fileError;
    if (![fileToUploadURL checkPromisedItemIsReachableAndReturnError:&fileError]) {
        // Could not read file data.
//        [self displayAlert:@"No Upload File Found"
//                    format:@"Path: %@", path];
        return;
    }
    GTLRDriveService *service = self.driveService;
    
    NSString *filename = [path lastPathComponent];
    NSString *mimeType = @"binary/octet-stream";
    GTLRUploadParameters *uploadParameters =
    [GTLRUploadParameters uploadParametersWithFileURL:fileToUploadURL
                                             MIMEType:mimeType];
    GTLRDrive_File *newFile = [GTLRDrive_File object];
    newFile.name = filename;
    
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:newFile
                                                                   uploadParameters:uploadParameters];
    
//    NSProgressIndicator *uploadProgressIndicator = _uploadProgressIndicator;
//    query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *callbackTicket,
//                                                      unsigned long long numberOfBytesRead,
//                                                      unsigned long long dataLength) {
//        uploadProgressIndicator.maxValue = (double)dataLength;
//        uploadProgressIndicator.doubleValue = (double)numberOfBytesRead;
//    };
    
    _uploadFileTicket = [service executeQuery:query
                            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                GTLRDrive_File *uploadedFile,
                                                NSError *callbackError) {
                                // Callback
                                self->_uploadFileTicket = nil;
                                if (callbackError == nil) {
//                                    [self displayAlert:@"Created"
//                                                format:@"Uploaded file \"%@\"",
//                                     uploadedFile.name];
                                    [self fetchFileList];
                                } else {
//                                    [self displayAlert:@"Upload Failed"
//                                                format:@"%@", callbackError];
                                }
//                                self->_uploadProgressIndicator.doubleValue = 0.0;
//                                [self updateUI];
                            }];

}

- (void)deleteSelectedFile:(GTLRDrive_File *)selectedFile {
    GTLRDriveService *service = self.driveService;
    NSString *fileID = selectedFile.identifier;
    if (fileID) {
        GTLRDriveQuery_FilesDelete *query = [GTLRDriveQuery_FilesDelete queryWithFileId:fileID];
        _editFileListTicket = [service executeQuery:query
                                  completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                      id nilObject,
                                                      NSError *callbackError) {
                                      // Callback
                                      self->_editFileListTicket = nil;
                                      if (callbackError == nil) {
                                          [self alertWithTitle:@"Deleted" message:[NSString stringWithFormat:@"Deleted \"%@\"",selectedFile.name]];
                                          [self fetchFileList];
                                      } else {
                                          [self alertWithTitle:@"Delete Failed" message:[NSString stringWithFormat:@"%@", callbackError]];
                                      }
                                  }];
    }
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
