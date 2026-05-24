/**
 * Like Minds Backend - Type Definitions
 * Central location for all TypeScript types and interfaces
 */

// ============================================
// API RESPONSE TYPES
// ============================================

export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  data?: T;
  timestamp: string;
  path: string;
}

export interface PaginationMeta {
  total: number;
  page: number;
  limit: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  meta: PaginationMeta;
}

// ============================================
// AUTH TYPES
// ============================================

export interface CurrentUserPayload {
  supabaseId: string;
  email: string;
  role?: string;
}

export interface JwtPayload {
  sub: string;
  email: string;
  aud: string;
  iat: number;
  exp: number;
}

export interface SupabaseUser {
  id: string;
  email: string;
  user_metadata: Record<string, unknown>;
}

// ============================================
// USER TYPES
// ============================================

export interface UserProfile {
  id: string;
  supabaseId: string | null;
  externalAuthId: string | null;
  email: string;
  fullName: string | null;
  username: string | null;
  phone: string | null;
  bio: string | null;
  dateOfBirth: string | null;
  gender: string | null;
  city: string | null;
  occupationStatus: string | null;
  personalityTypes: string[];
  socialComfort: string | null;
  selectedInterestIds: string[];
  hobbiesNarrative: string | null;
  authProvider: string | null;
  profileImageUrl: string | null;
  meetupsAttended: number;
  meetupsHosted: number;
  badges: string[];
  favoriteCommunities: string[];
  isOnboarded: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface UserWithInterests extends UserProfile {
  interests: UserInterest[];
}

export interface UserInterest {
  id: string;
  interest: {
    id: string;
    name: string;
    slug: string;
    icon?: string;
  };
  proficiencyLevel?: string;
}

// ============================================
// COMMUNITY TYPES
// ============================================

export interface CommunityProfile {
  id: string;
  name: string;
  slug: string;
  description?: string;
  imageUrl?: string;
  bannerImageUrl?: string;
  interest: {
    id: string;
    name: string;
  };
  creator: {
    id: string;
    username?: string;
    profileImageUrl?: string;
  };
  memberCount: number;
  isJoined?: boolean;
  userRole?: string;
  createdAt: Date;
}

export interface CommunityMember {
  id: string;
  userId: string;
  communityId: string;
  role: 'ADMIN' | 'MODERATOR' | 'MEMBER';
  joinedAt: Date;
  status: 'ACTIVE' | 'INACTIVE' | 'BANNED';
}

// ============================================
// MEETUP TYPES
// ============================================

export interface MeetupProfile {
  id: string;
  title: string;
  description?: string;
  community: {
    id: string;
    name: string;
    slug: string;
  };
  creator: {
    id: string;
    username?: string;
    profileImageUrl?: string;
  };
  location: string;
  latitude?: number;
  longitude?: number;
  startTime: Date;
  endTime: Date;
  maxAttendees?: number;
  imageUrl?: string;
  rsvpCount: number;
  status: 'SCHEDULED' | 'ONGOING' | 'COMPLETED' | 'CANCELLED';
  userRsvpStatus?: 'GOING' | 'MAYBE' | 'NOT_GOING' | 'CANCELLED';
  createdAt: Date;
}

export interface MeetupRSVP {
  id: string;
  meetupId: string;
  userId: string;
  status: 'GOING' | 'MAYBE' | 'NOT_GOING' | 'CANCELLED';
  rsvpedAt: Date;
  checkedInAt?: Date;
  notes?: string;
}

// ============================================
// NOTIFICATION TYPES
// ============================================

export interface NotificationProfile {
  id: string;
  type:
    | 'FOLLOW_REQUEST'
    | 'FOLLOW_ACCEPTED'
    | 'COMMUNITY_INVITE'
    | 'MEETUP_INVITE'
    | 'MEETUP_REMINDER'
    | 'MEETUP_UPDATED'
    | 'MEMBER_JOINED_COMMUNITY'
    | 'NEW_MEETUP'
    | 'COMMUNITY_ANNOUNCEMENT';
  title: string;
  message: string;
  relatedEntityId?: string;
  isRead: boolean;
  readAt?: Date;
  createdAt: Date;
}

// ============================================
// PAGINATION TYPES
// ============================================

export interface PaginationQuery {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

// ============================================
// ERROR TYPES
// ============================================

export interface ErrorResponse {
  statusCode: number;
  message: string;
  details?: Record<string, unknown>;
  timestamp: string;
  path: string;
}

export class CustomError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = 'CustomError';
  }
}
