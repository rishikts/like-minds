import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsIn,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

export class UpdateUserProfileDto {
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
}
