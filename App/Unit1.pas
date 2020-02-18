unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Layouts, FMX.TabControl, FMX.StdCtrls,
  FMX.Controls.Presentation, Data.FireDACJSONReflect, Data.db,
  System.Permissions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.dialogservice, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.Surfaces,
  System.ImageList, FMX.ImgList

{$IF Defined(ANDROID)}
    , FMX.Helpers.Android,
  Androidapi.jni.app,
  Androidapi.jni.GraphicsContentViewText,
  Androidapi.jni.Net,
  Androidapi.Helpers,
  Androidapi.jni.Support,
  Androidapi.JNIBridge,
  Androidapi.NativeActivity,
  Androidapi.jni.JavaTypes,
  Androidapi.jni.Os
{$ENDIF};

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Layout1: TLayout;
    Layout2: TLayout;
    Circle1: TCircle;
    Layout3: TLayout;
    edtNome: TEdit;
    Layout4: TLayout;
    edtTelefone: TEdit;
    Layout5: TLayout;
    edtEmail: TEdit;
    Layout6: TLayout;
    edtCPF: TEdit;
    StyleBook1: TStyleBook;
    Layout7: TLayout;
    Rectangle2: TRectangle;
    Label2: TLabel;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ToolBar1: TToolBar;
    Rectangle1: TRectangle;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    ToolBar2: TToolBar;
    Rectangle3: TRectangle;
    Label3: TLabel;
    ChangeTabAction2: TChangeTabAction;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton5: TSpeedButton;
    Circle2: TCircle;
    LinkListControlToField1: TLinkListControlToField;
    procedure Rectangle2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ListView1PullRefresh(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure Circle2Click(Sender: TObject);
  private

    FPermissionCamera, FPermissionReadExternalStorage,
      FPermissionWriteExternalStorage: string;

    procedure DisplayRationale(Sender: TObject;
      const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure TakePicturePermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
    procedure TakeCameraPermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
    procedure PermissionGaleria;
    procedure PermissionCamera;

    procedure AtualizaCliente;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses ClientModuleUnit1;

procedure TForm1.AtualizaCliente;
var
  LDataSetList: TFDJSONDataSets;
begin
  with ClientModule1 do
  begin

    LDataSetList := ServerMethods1Client.Cliente;
    fdCliente.Active := False;
    fdCliente.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));

  end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem2;
  TabControl1.TabPosition := TTabPosition.None;
  self.AtualizaCliente;
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  mSize: TMemoryStream;
begin
  mSize := TMemoryStream.Create;
  mSize.Position := 0;

  with ClientModule1 do
  begin
    if not fdCliente.Active then
      fdCliente.Open;
    fdCliente.Edit;
    edtNome.Text := FdClienteNOME.AsString;
    edtTelefone.Text := FdClienteTELEFONE.AsString;
    edtEmail.Text := FdClienteEMAIL.AsString;
    edtCPF.Text := FdClienteCPF.AsString;
    FdClienteFOTO.SaveToStream(mSize);
    mSize.Position := 0;
    if mSize.Size > -1 then
    begin

      Circle1.Fill.Kind := TBrushKind.Bitmap;
      Circle1.Fill.Bitmap.Bitmap.LoadFromStream(mSize);
      Circle1.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;

    end;
    ChangeTabAction2.ExecuteTarget(nil);

  end;
end;

procedure TForm1.ListView1PullRefresh(Sender: TObject);
begin
  self.AtualizaCliente;

end;

procedure TForm1.Rectangle2Click(Sender: TObject);
var
  LDeltaList: TFDJSONDeltas;
  mSize: TMemoryStream;

begin
  with ClientModule1 do
  begin
    try
      FdClienteNOME.AsString := edtNome.Text;
      FdClienteCPF.AsString := edtCPF.Text;
      FdClienteEMAIL.AsString := edtEmail.Text;
      FdClienteTELEFONE.AsString := edtTelefone.Text;
      fdCliente.Post;

      LDeltaList := TFDJSONDeltas.Create;
      TFDJSONDeltasWriter.ListAdd(LDeltaList, 'CLIENTES', fdCliente);
      ServerMethods1Client.updateCliente(LDeltaList);

      ShowMessage('Cadastro Realizado Com Sucesso!');
      ChangeTabAction1.ExecuteTarget(nil);
    except
      on E: Exception do
        ShowMessage('Erro ao Cadastrar ' + E.Message);

    end;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  self.AtualizaCliente;
  ChangeTabAction1.ExecuteTarget(nil);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  ChangeTabAction2.ExecuteTarget(nil);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
{$IF Defined(IOS)}
  TakePhotoFromCameraAction1.Execute;
{$ENDIF}
{$IF Defined(ANDROID)}
  PermissionCamera;
{$ENDIF}
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
{$IF Defined(IOS)}
  TakePhotoFromLibraryAction1.Execute;
{$ENDIF}
{$IF Defined(ANDROID)}
  PermissionGaleria;
{$ENDIF}
end;

procedure TForm1.PermissionCamera;
begin
{$IF Defined(ANDROID)}
  FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  FPermissionReadExternalStorage :=
    JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  FPermissionWriteExternalStorage :=
    JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);

  if ((TJContextCompat.JavaClass.checkSelfPermission(TAndroidHelper.Activity,
    TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE) <>
    TJPackageManager.JavaClass.PERMISSION_GRANTED) or
    (TJContextCompat.JavaClass.checkSelfPermission(TAndroidHelper.Activity,
    TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE) <>
    TJPackageManager.JavaClass.PERMISSION_GRANTED) or
    (TJContextCompat.JavaClass.checkSelfPermission(TAndroidHelper.Activity,
    TJManifest_permission.JavaClass.CAMERA) <>
    TJPackageManager.JavaClass.PERMISSION_GRANTED)) then
  begin
    PermissionsService.RequestPermissions([FPermissionReadExternalStorage,
      FPermissionWriteExternalStorage, FPermissionCamera],
      TakeCameraPermissionRequestResult, DisplayRationale);
  end
  else
    TakePhotoFromCameraAction1.Execute;
{$ENDIF}
end;

procedure TForm1.PermissionGaleria;
begin
{$IF Defined(ANDROID)}
  begin
    FPermissionCamera := JStringToString
      (TJManifest_permission.JavaClass.CAMERA);
    FPermissionReadExternalStorage :=
      JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    FPermissionWriteExternalStorage :=
      JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);

    if ((TJContextCompat.JavaClass.checkSelfPermission(TAndroidHelper.Activity,
      TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE) <>
      TJPackageManager.JavaClass.PERMISSION_GRANTED) or
      (TJContextCompat.JavaClass.checkSelfPermission(TAndroidHelper.Activity,
      TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE) <>
      TJPackageManager.JavaClass.PERMISSION_GRANTED) or
      (TJContextCompat.JavaClass.checkSelfPermission(TAndroidHelper.Activity,
      TJManifest_permission.JavaClass.CAMERA) <>
      TJPackageManager.JavaClass.PERMISSION_GRANTED)) then
    begin
      PermissionsService.RequestPermissions([FPermissionReadExternalStorage,
        FPermissionWriteExternalStorage, FPermissionCamera],
        TakePicturePermissionRequestResult, DisplayRationale);
    end
    else
      TakePhotoFromLibraryAction1.Execute;
  end;
{$ENDIF}
end;

procedure TForm1.Circle2Click(Sender: TObject);
begin
  with ClientModule1 do
  begin
    if not fdCliente.Active then
      fdCliente.Open;
    fdCliente.Insert;
    edtNome.Text := '';
    edtTelefone.Text := '';
    edtEmail.Text := '';
    edtCPF.Text := '';
    Circle1.Fill.Kind := TBrushKind.Solid;
    ChangeTabAction2.ExecuteTarget(nil);

  end;

end;

procedure TForm1.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do
  begin
    if APermissions[I] = FPermissionCamera then
      RationaleMsg := RationaleMsg +
        'The app needs to access the camera to take a photo' + SLineBreak +
        SLineBreak
    else if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg +
        'The app needs to read a photo file from your device';
  end;

  // Show an explanation to the user *asynchronously* - don't block this thread waiting for the user's response!
  // After the user sees the explanation, invoke the post-rationale routine to request the permissions
  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end);
end;

procedure TForm1.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
var
  saveParams: TBitmapCodecSaveParams;
  Surf: TBitmapSurface;
  BmpOut: TBitmap;
  mSize: TMemoryStream;
  t: TBitmapCodecManager;
  LDeltaList: TFDJSONDeltas;

begin
  mSize := TMemoryStream.Create;
  mSize.Position := 0;
  Image.SaveToStream(mSize);

  Surf := TBitmapSurface.Create;
  try
    Surf.Assign(Image);
    saveParams.Quality := 50;
    TBitmapCodecManager.SaveToStream(mSize, Surf, '.jpg', @saveParams);
  finally
    Surf.Free;
  end;

  mSize.Position := 0;
  BmpOut := TBitmap.Create;
  BmpOut.LoadFromStream(mSize);
  Circle1.Fill.Kind := TBrushKind.Bitmap;
  Circle1.Fill.Bitmap.Bitmap := BmpOut;
  Circle1.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  ClientModule1.FdClienteFOTO.LoadFromStream(mSize);

end;

procedure TForm1.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
var
  saveParams: TBitmapCodecSaveParams;
  Surf: TBitmapSurface;
  BmpOut: TBitmap;
  mSize: TMemoryStream;
  t: TBitmapCodecManager;
  LDeltaList: TFDJSONDeltas;

begin
  mSize := TMemoryStream.Create;
  mSize.Position := 0;
  Image.SaveToStream(mSize);

  Surf := TBitmapSurface.Create;
  try
    Surf.Assign(Image);
    saveParams.Quality := 50;
    TBitmapCodecManager.SaveToStream(mSize, Surf, '.jpg', @saveParams);
  finally
    Surf.Free;
  end;

  mSize.Position := 0;
  BmpOut := TBitmap.Create;
  BmpOut.LoadFromStream(mSize);
  Circle1.Fill.Kind := TBrushKind.Bitmap;
  Circle1.Fill.Bitmap.Bitmap := BmpOut;
  Circle1.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  ClientModule1.FdClienteFOTO.LoadFromStream(mSize);

end;

procedure TForm1.TakePicturePermissionRequestResult(Sender: TObject;
const APermissions: TArray<string>;
const AGrantResults: TArray<TPermissionStatus>);
begin
  // 3 permissions involved: CAMERA, READ_EXTERNAL_STORAGE and WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 3) and
    (AGrantResults[0] = TPermissionStatus.Granted) and
    (AGrantResults[1] = TPermissionStatus.Granted) and
    (AGrantResults[2] = TPermissionStatus.Granted) then
    TakePhotoFromLibraryAction1.Execute
  else
    TDialogService.ShowMessage
      ('Cannot take a photo because the required permissions are not all granted');
end;

procedure TForm1.TakeCameraPermissionRequestResult(Sender: TObject;
const APermissions: TArray<string>;
const AGrantResults: TArray<TPermissionStatus>);
begin
  // 3 permissions involved: CAMERA, READ_EXTERNAL_STORAGE and WRITE_EXTERNAL_STORAGE
  if (Length(AGrantResults) = 3) and
    (AGrantResults[0] = TPermissionStatus.Granted) and
    (AGrantResults[1] = TPermissionStatus.Granted) and
    (AGrantResults[2] = TPermissionStatus.Granted) then
    TakePhotoFromCameraAction1.Execute
  else
    TDialogService.ShowMessage
      ('Cannot take a photo because the required permissions are not all granted');
end;

end.
