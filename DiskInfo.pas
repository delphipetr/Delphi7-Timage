{*************************************************************}
{            DiskInfo component for Delphi 32                 }
{ Version:   2.0                                              }
{ E-Mail:    info@utilmind.com                                }
{ WWW:       http://www.utilmind.com                          }
{ Created:   May, 4, 1999                                     }
{ Modified:  June, 11, 2000                                   }
{ Legal:     Copyright (c) 1999-2000, UtilMind Solutions      }
{*************************************************************}
{  TDiskInfo:                                                 }
{ Component determines the information about specified local  }
{ or a network disk - Serial number, Volume label, type of    }
{ file system, type of a disk, size of disk and free space.   }
{                                                             }
{  REMARK for Delphi 2 and 3                                  }
{ The DiskSize and DiskFree properties returns incorrect      }
{ values for volumes that are larger than 2 gigabytes (FAT32  }
{ file system) because Delphi 2 and 3 don't support 64-bit    }
{ integer operations.                                         }
{*************************************************************}
{ PROPERTIES:                                                 }
{   Disk: Char - Drive letter                                 }
{                                                             }
{ READ-ONLY PROPERTIES (results)                              }
{   SerialNumberStr: String                                   }
{   SerialNumber: LongInt                                     }
{   VolumeLabel: String                                       }
{   FileSystem: String                                        }
{   DriveType: TDriveType                                     }
{   DiskSize: Int64 (DWord in Delphi 2 and 3)                 }
{   DiskFree: Int64 (DWord in Delphi 2 and 3)                 }
{*************************************************************}
{ Please see demo program for more information.               }
{*************************************************************}
{                     IMPORTANT NOTE:                         }
{ This software is provided 'as-is', without any express or   }
{ implied warranty. In no event will the author be held       }
{ liable for any damages arising from the use of this         }
{ software.                                                   }
{ Permission is granted to anyone to use this software for    }
{ any purpose, including commercial applications, and to      }
{ alter it and redistribute it freely, subject to the         }
{ following restrictions:                                     }
{ 1. The origin of this software must not be misrepresented,  }
{    you must not claim that you wrote the original software. }
{    If you use this software in a product, an acknowledgment }
{    in the product documentation would be appreciated but is }
{    not required.                                            }
{ 2. Altered source versions must be plainly marked as such,  }
{    and must not be misrepresented as being the original     }
{    software.                                                }
{ 3. This notice may not be removed or altered from any       }
{    source distribution.                                     }
{*************************************************************}


unit DiskInfo;

interface

uses
  Windows, Classes, SysUtils;

{$IFDEF VER90}      {Delphi 2.0}
  {$DEFINE NO64}
{$ENDIF}
{$IFDEF VER93}      {BCB 1.0}
  {$DEFINE NO64}
{$ENDIF}
{$IFDEF VER100}     {Delphi 3}
  {$DEFINE NO64}
{$ENDIF}
{$IFDEF VER110}     {BCB 3}
  {$DEFINE NO64}
{$ENDIF}
{$IFDEF NO64}
type
  Int64 = DWord; // Delphi2 and 3 haven't Int64
{$ENDIF}  

type
  TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM);

  TDiskInfo = class(TComponent)
  private
    FDisk: Char;
    FSerialNumberStr: String;
    FSerialNumber: LongInt;
    FVolumeLabel: String;
    FFileSystem: String;
    FDriveType: TDriveType;
    FDiskSize: Int64;
    FDiskFree: Int64;

    procedure SetDisk(Value: Char);

    procedure SetNothing(Value: String); procedure SetNothingLong(Value: LongInt); procedure SetNothingInt64(Value: Int64); procedure SetNothingDT(Value: TDriveType);
  protected
  public
    constructor Create(aOwner: TComponent); override;
  published
    property Disk: Char read FDisk write SetDisk;
    property SerialNumberStr: String read FSerialNumberStr write SetNothing;
    property SerialNumber: LongInt read FSerialNumber write SetNothingLong;
    property VolumeLabel: String read FVolumeLabel write SetNothing;
    property FileSystem: String read FFileSystem write SetNothing;
    property DriveType: TDriveType read FDriveType write SetNothingDT;
    property DiskSize: Int64 read FDiskSize write SetNothingInt64;
    property DiskFree: Int64 read FDiskFree write SetNothingInt64;
  end;

procedure Register;

implementation

constructor TDiskInfo.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Disk := 'C';
end;

procedure TDiskInfo.SetDisk(Value: Char);
var
  VolumeLabel, FileSystem: Array[0..$FF] of Char;
  SerialNumber, DW, SysFlags: DWord;

  function DecToHex(aValue: LongInt): String;
  var
    w: Array[1..2] of Word absolute aValue;

    function HexByte(b: Byte): String;
    const
      Hex: Array[$0..$F] of Char = '0123456789ABCDEF';
    begin
      HexByte := Hex[b shr 4] + Hex[b and $F];
    end;

    function HexWord(w: Word): String;
    begin
      HexWord := HexByte(Hi(w)) + HexByte(Lo(w));
    end;

  begin
    Result := HexWord(w[2]) + HexWord(w[1]);
  end;

begin
  Value := UpCase(Value);
  if (Value >= 'A') and (Value <= 'Z') then
   begin
    FDisk := Value;
    GetVolumeInformation(PChar(Value + ':\'), VolumeLabel, SizeOf(VolumeLabel),
                         @SerialNumber, DW, SysFlags,
                         FileSystem, SizeOf(FileSystem));
    FSerialNumber := SerialNumber;
    FSerialNumberStr := DecToHex(SerialNumber);
    Insert('-', FSerialNumberStr, 5);
    FVolumeLabel := VolumeLabel;
    FFileSystem := FileSystem;
    FDriveType := TDriveType(GetDriveType(PChar(Value + ':\')));

    FDiskSize := SysUtils.DiskSize(Byte(Value) - $40);
    FDiskFree := SysUtils.DiskFree(Byte(Value) - $40);
   end
end;

procedure TDiskInfo.SetNothing(Value: String); begin {} end; procedure TDiskInfo.SetNothingLong(Value: LongInt); begin {} end; procedure TDiskInfo.SetNothingInt64(Value: Int64); begin {} end; procedure TDiskInfo.SetNothingDT(Value: TDriveType); begin {} end;

procedure Register;
begin
  RegisterComponents('system', [TDiskInfo]);
end;

end.
