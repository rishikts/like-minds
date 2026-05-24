import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export class SyncUserProfileDto {
  @IsString()
  @MinLength(1)
  externalAuthId!: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsIn(['apple', 'google', 'guest'])
  authProvider?: string;

  @IsOptional()
  @IsString()
  @MaxLength(150)
  fullName?: string;

  @IsOptional()
  @IsString()
  @MaxLength(20)
  phone?: string;

  @IsOptional()
  @IsString()
  @MinLength(3)
  @MaxLength(24)
  username?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  bio?: string;

  @IsOptional()
  @IsDateString()
  dateOfBirth?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  gender?: string;

  @IsOptional()
  @IsString()
  @MaxLength(255)
  city?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  occupationStatus?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  personalityTypes?: string[];

  @IsOptional()
  @IsIn(['introvert', 'balanced', 'extrovert'])
  socialComfort?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  selectedInterestIds?: string[];

  @IsOptional()
  @IsString()
  @MaxLength(300)
  hobbiesNarrative?: string;

  @IsOptional()
  @IsString()
  profileImageUrl?: string;

  @IsOptional()
  @IsBoolean()
  isOnboarded?: boolean;

  @IsOptional()
  @IsString()
  supabaseId?: string;
}
